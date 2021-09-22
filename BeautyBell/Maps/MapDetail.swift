//
//  MapDetail.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 21/09/21.
//

import UIKit
import RxSwift
import RxCocoa
import GooglePlaces
class MapDetailViewController: UIViewController {
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    let selectedLocation = PublishSubject<Location>()
    let disposeBag = DisposeBag()
    
    var fetcher: GMSAutocompleteFetcher?
    let placesClient = GMSPlacesClient.init()
    var placesCells: Observable<[GMSPlace]> {
            return placesArray.asObservable()
        }
    var placesArray = BehaviorRelay<[GMSPlace]>(value: [])
    lazy var tableView: UITableView = {
        let v = UITableView(frame: self.view.bounds)
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        return v
    }()
    var searchDelegate: SearchControllerDelegate?
    
    override func viewDidLoad() {
        let filter = GMSAutocompleteFilter()
        filter.countries = ["ID"]
        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
        fetcher = GMSAutocompleteFetcher(filter: filter)
        fetcher?.delegate = self
        fetcher?.provide(token)
        view.addSubview(tableView)
        tableView.isHidden = true
        binding()
    }
    
    private func binding(){
        selectedLocation.asObservable().subscribe(onNext: { [weak self] location in
            self?.addressLabel.text = location.Title
            self?.regionLabel.text = "\(location.latitude), \(location.longitude)"
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didTapSelect(_ sender: UIButton){
        
    }


}
extension MapDetailViewController: GMSAutocompleteFetcherDelegate {
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


