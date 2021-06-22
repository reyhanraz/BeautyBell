//
//  DetailArtisanViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 22/06/21.
//

import UIKit

class DetailArtisanViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
       let collView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collView.register(UINib(nibName: "DetailArtisanCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailArtisanCollectionViewCell")
        
        return collView
    }()
    var services = [Service]()
    var APIservice: APIServices?
    var artisanID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        fetchDetailArtisan()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 0)
        layout.minimumInteritemSpacing = 4.0
        layout.minimumLineSpacing = 4.0
        layout.itemSize = CGSize(width: 180, height: 185)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    override func viewWillLayoutSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func fetchDetailArtisan(){
    APIservice!.getAllServises(artisanID!)
    APIservice?.completionHandlerServices { [weak self] services, status, message in

        if status{
            guard let self = self else {return}
            guard let _services = services else {
                return
            }
            self.services = _services
            print(self.services)

                self.collectionView.reloadData()
            
        }
    }
    }

}

extension DetailArtisanViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailArtisanCollectionViewCell", for: indexPath) as! DetailArtisanCollectionViewCell
        cell.service = services[indexPath.row]
        return cell
    }
    
    
}
