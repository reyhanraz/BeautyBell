//
//  DetailArtisanViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 22/06/21.
//

import UIKit
import RxSwift

class DetailArtisanViewController: UIViewController {
    var artisanHeader = DetailArtisanHeader()
    lazy var collectionView: UICollectionView = {
       let collView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collView.register(UINib(nibName: "DetailArtisanCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailArtisanCollectionViewCell")
        collView.backgroundColor = .red
        return collView
    }()
    let disposeBag = DisposeBag()
    let _listViewModel = ListViewModel()
    var artisanViewModel: ArtisanViewModel?
    
    init(artisanViewModel: ArtisanViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.artisanViewModel = artisanViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "Detail Artisan"
        view.backgroundColor = .white
        initUI(artiasn: artisanViewModel!)
        fetchDetailArtisan()
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutCollectionView()
    }

}

extension DetailArtisanViewController{
    private func initUI(artiasn: ArtisanViewModel){
        artisanHeader.artisan = artiasn
        view.addSubview(collectionView)
        view.addSubview(artisanHeader)
        binding()
    }
    private func fetchDetailArtisan(){
//        let APIservice = APIServices()
//        APIservice.getAllServises(artisanViewModel!.artisanID)
//        APIservice.completionHandlerServices { [weak self] services, status, message in
//            if status{
//                guard let self = self else {return}
//                guard let _services = services else {
//                    return
//                }
//                self.services = _services.map({ServiceViewModel(service: $0)})
//                self.collectionView.reloadData()
//            }
//        }
        
    }
    
    func binding(){
        _listViewModel.getArtisanByID(id: Int(artisanViewModel!.artisanID)!)
            .asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: "DetailArtisanCollectionViewCell", cellType: DetailArtisanCollectionViewCell.self)){row,model,cell in
                print(model)
                cell.service = model
            }.disposed(by: disposeBag)
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        layout.minimumInteritemSpacing = 4.0
        layout.minimumLineSpacing = 4.0
        layout.itemSize = CGSize(width: 180, height: 185)
        collectionView.setCollectionViewLayout(layout, animated: true)
//        collectionView.delegate = self
//        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
    }
    
    private func layoutCollectionView(){

        artisanHeader.translatesAutoresizingMaskIntoConstraints = false
        artisanHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        artisanHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        artisanHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        artisanHeader.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: artisanHeader.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//extension DetailArtisanViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return services.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailArtisanCollectionViewCell", for: indexPath) as! DetailArtisanCollectionViewCell
//        cell.service = services[indexPath.row]
//        return cell
//    }
//
//
//}
