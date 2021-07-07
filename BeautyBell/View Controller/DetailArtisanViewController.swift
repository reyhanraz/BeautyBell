//
//  DetailArtisanViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 22/06/21.
//

import UIKit

class DetailArtisanViewController: UIViewController {
    lazy var imageArtisan: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 75
        image.image = UIImage(named: "Placeholder")
        return image
    }()
    lazy var lblArtisanName: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        return lbl
    }()
    lazy var lblArtisanDesc: UILabel = {
        let lbl = UILabel()
        lbl.text = "Description"
        lbl.numberOfLines = 0
        return lbl
    }()
    lazy var collectionView: UICollectionView = {
       let collView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collView.register(UINib(nibName: "DetailArtisanCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailArtisanCollectionViewCell")
        
        return collView
    }()
    var services = [ServiceViewModel]()
    var artisanViewModel: ArtisanViewModel?
    
    init(artisan: ArtisanViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.artisanViewModel = artisan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "Detail Artisan"
        view.backgroundColor = .white
        initUI()
        fetchDetailArtisan()
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutCollectionView()
    }

}

extension DetailArtisanViewController{
    private func initUI(){
        view.addSubview(collectionView)
        view.addSubview(imageArtisan)
        view.addSubview(lblArtisanName)
        view.addSubview(lblArtisanDesc)
        artisanViewModel?.loadImage(completion: { image in
            DispatchQueue.main.async {
                self.imageArtisan.image = image
            }
        })
        self.lblArtisanName.text = artisanViewModel?.artisanName
        self.lblArtisanDesc.text = artisanViewModel?.artisanDescString
    }
    private func fetchDetailArtisan(){
        let APIservice = APIServices()
        APIservice.getAllServises(artisanViewModel!.artisanID)
        APIservice.completionHandlerServices { [weak self] services, status, message in
            if status{
                guard let self = self else {return}
                guard let _services = services else {
                    return
                }
                self.services = _services.map({ServiceViewModel(service: $0)})
                self.collectionView.reloadData()
            }
        }
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 4.0
        layout.minimumLineSpacing = 4.0
        layout.itemSize = CGSize(width: 180, height: 185)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    private func layoutCollectionView(){
        imageArtisan.translatesAutoresizingMaskIntoConstraints = false
        imageArtisan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageArtisan.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imageArtisan.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageArtisan.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        lblArtisanName.translatesAutoresizingMaskIntoConstraints = false
        lblArtisanName.leadingAnchor.constraint(equalTo: imageArtisan.trailingAnchor, constant: 20).isActive = true
        lblArtisanName.topAnchor.constraint(equalTo: imageArtisan.topAnchor).isActive = true
        lblArtisanName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        lblArtisanName.heightAnchor.constraint(equalToConstant: 40).isActive = true

        lblArtisanDesc.translatesAutoresizingMaskIntoConstraints = false
        lblArtisanDesc.leadingAnchor.constraint(equalTo: imageArtisan.leadingAnchor).isActive = true
        lblArtisanDesc.topAnchor.constraint(equalTo: imageArtisan.bottomAnchor, constant: 16).isActive = true
        lblArtisanDesc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        lblArtisanDesc.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: lblArtisanDesc.bottomAnchor, constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
