//
//  HomeViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import UIKit
import AlamofireImage

class HomeViewController: UIViewController {
    lazy var tableView:UITableView = {
        let tableVIew = UITableView()
        tableVIew.register(UINib(nibName: "ArtisanTableViewCell", bundle: nil), forCellReuseIdentifier: "ArtisanTableViewCell")
        return tableVIew
    }()
    lazy var artisanLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "List Artisan"
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        return lbl
    }()
    var Artisans = [ArtisanViewModel]()
    var searchResult = [ArtisanViewModel]()
    let service = APIServices()
    let searchController = UISearchController(searchResultsController: nil)



    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.image = UIImage(systemName: "house")
        self.navigationItem.largeTitleDisplayMode = .always
        searchController.searchResultsUpdater = self
        view.backgroundColor = .white
        setupTableView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.setHidesBackButton(true, animated: true)
        self.definesPresentationContext = true
        self.parent?.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        self.title = "Home"
        self.parent?.title = self.title
    }
}

extension HomeViewController{
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(artisanLabel)
        view.addSubview(tableView)
        service.getAllArtisan()
        service.completionHandlerArtisan { [weak self] artisans, status, message in
            if status{
                guard let self = self else {return}
                guard let _artisans = artisans else {
                    return
                }
                self.Artisans = _artisans.map({ArtisanViewModel(Artisan: $0)})
                self.tableView.reloadData()
            }
        }
    }
    
    func layoutTableView(){
        artisanLabel.translatesAutoresizingMaskIntoConstraints = false
        artisanLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        artisanLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        artisanLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        artisanLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: artisanLabel.bottomAnchor, constant: 16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func filterContent(for searchText: String) {
        
        searchResult = Artisans.filter({ (artisan: ArtisanViewModel) -> Bool in
            let match = artisan.artisanName.range(of: searchText, options: .caseInsensitive)
                return match != nil
            })
        }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResult.count : Artisans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtisanTableViewCell") as! ArtisanTableViewCell
        let artisanViewModel = searchController.isActive ? searchResult[indexPath.row] : Artisans[indexPath.row]
        cell.artisanViewModel = artisanViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detilVC = DetailArtisanViewController(artisan: Artisans[indexPath.row])
        self.navigationController?.pushViewController(detilVC, animated: true)
    }
}

extension HomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    
}
