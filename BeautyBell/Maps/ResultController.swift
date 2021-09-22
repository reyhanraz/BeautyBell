//
//  ResultController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 22/09/21.
//

import Foundation
import GooglePlaces
import RxSwift
import RxCocoa

class ResultController:UIViewController, UISearchResultsUpdating{
    var fetcher: GMSAutocompleteFetcher?
    let placesClient = GMSPlacesClient.init()
    var placesCells: Observable<[GMSPlace]> {
            return placesArray.asObservable()
        }
    var placesArray = BehaviorRelay<[GMSPlace]>(value: [])
    let disposeBag = DisposeBag()
    lazy var tableView: UITableView = {
        let v = UITableView(frame: self.view.bounds)
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        return v
    }()
    var searchDelegate: SearchControllerDelegate?
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        let filter = GMSAutocompleteFilter()
        filter.countries = ["ID"]
        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
        fetcher = GMSAutocompleteFetcher(filter: filter)
        fetcher?.delegate = self
        fetcher?.provide(token)
        view.addSubview(tableView)
        binding()
    }
    
    func binding(){
        placesCells.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){row,model,cell in
                var content = cell.defaultContentConfiguration()
                content.text = model.name
                content.secondaryText = model.formattedAddress
                cell.contentConfiguration = content
        }.disposed(by: disposeBag)
        tableView.rx.modelSelected(GMSPlace.self).subscribe(onNext: {[weak self] item in
            self?.dismiss(animated: true, completion: nil)
            self?.searchDelegate?.placeClicked(place: item)
                    print("SelectedItem: \(item)")
                }).disposed(by: disposeBag)
        

    }
    
    deinit {
        print("deinit")
    }
    func textFieldDidChange(_ string: String) {
        fetcher?.sourceTextHasChanged(string)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
        }
        placesArray.accept([])
        textFieldDidChange(query)
    }
    
    
}

extension ResultController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions{
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))
            placesClient.fetchPlace(fromPlaceID: prediction.placeID, placeFields: fields, sessionToken: nil, callback: { [weak self]
                (places: GMSPlace?, error: Error?) in
              if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
              }
                    self?.placesArray.accept((self?.placesArray.value)! + [places!])
            })

        }
        
    }

    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
  }

protocol SearchControllerDelegate {
    func placeClicked(place: GMSPlace)
}
