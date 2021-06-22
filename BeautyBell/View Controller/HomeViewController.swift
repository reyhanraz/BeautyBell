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
    var Artisans = [Artisan]()
    var searchResult = [Artisan]()
    let service = APIServices(baseURL: "https://604048b4f34cf600173c7cda.mockapi.io/api/v1/list-artisan")
    let searchController = UISearchController(searchResultsController: nil)



    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.parent?.navigationItem.setHidesBackButton(true, animated: true)
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.parent?.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        view.backgroundColor = .white
        setupTableView()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutTableView()
    }
}

extension HomeViewController{
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        service.getAllArtisan()
        service.completionHandlerArtisan { [weak self] artisans, status, message in
            if status{
                guard let self = self else {return}
                guard let _artisans = artisans else {
                    return
                }
                self.Artisans = _artisans
                self.tableView.reloadData()
            }
        }
    }
    
    func layoutTableView(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func filterContent(for searchText: String) {
            searchResult = Artisans.filter({ (artisan: Artisan) -> Bool in
                let match = artisan.name.range(of: searchText, options: .caseInsensitive)
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
        let artisan = searchController.isActive ? searchResult[indexPath.row] : Artisans[indexPath.row]
        cell.artisan = artisan
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detilVC = DetailArtisanViewController()
        detilVC.APIservice = service
        detilVC.artisanID = Artisans[indexPath.row].id
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
