//
//  MapViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi Azzami on 13/09/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RxSwift
import RxCocoa

struct Location{
    let Title: String?
    let latitude: Double
    let longitude: Double
}

class MapViewController: UIViewController {
    lazy var myMaps: GMSMapView = {
        let position = CLLocationCoordinate2D(latitude: -6.2051, longitude: 106.84)
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: 10)
        let map = GMSMapView(frame: view.bounds, camera: camera)
        map.isMyLocationEnabled = true
        map.settings.compassButton = true
        map.settings.myLocationButton = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.settings.consumesGesturesInView = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(_:)))
        map.addGestureRecognizer(panGesture)
        return map
    }()
    
    lazy var pinImage : UIImageView = {
        let img = UIImageView()
        let marker = UIImage(named: "mapMarker")
        img.image = marker
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    enum CardState {
        case collapsed
        case expanded
    }
        var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var mapDetailViewController:MapDetailViewController!
    
    var endCardHeight:CGFloat = 0
    var startCardHeight:CGFloat = 100
    
    var cardVisible = false
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    let geoCoder = GMSGeocoder()
    let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height:70))
    
    let selectedLocation = PublishSubject<Location>()
    let disposeBag = DisposeBag()
    
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        myMaps.delegate = self
        
        self.title = "Belajar Map"
        setupSpinner()
        view.addSubview(myMaps)
        view.addSubview(pinImage)
        
        definesPresentationContext = true
        let result = ResultController()
        result.searchDelegate = self
        searchController = UISearchController(searchResultsController: result)
        searchController?.searchResultsUpdater = result
        searchController?.hidesNavigationBarDuringPresentation = false
        
        setupCard()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        myMaps.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myMaps.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myMaps.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        myMaps.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -startCardHeight).isActive = true
        
        pinImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        pinImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        pinImage.centerXAnchor.constraint(equalTo: myMaps.centerXAnchor).isActive = true
        pinImage.bottomAnchor.constraint(equalTo: myMaps.centerYAnchor).isActive = true
    }
    
    func setupSpinner(){
        spinner.color = UIColor.black
        self.spinner.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.spinner.center = CGPoint(x:UIScreen.main.bounds.size.width / 2, y:UIScreen.main.bounds.size.height / 2)
        self.view.addSubview(spinner)
        spinner.hidesWhenStopped = true
    }

}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate{
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let lat = myMaps.myLocation?.coordinate.latitude,
                let lng = myMaps.myLocation?.coordinate.longitude else { return false }

            let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: 18)
            myMaps.animate(to: camera)
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        selectedLocation.onNext(Location(Title: name, latitude: location.latitude, longitude: location.longitude))
        let camera = GMSCameraPosition(latitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        myMaps.animate(to: camera)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        spinner.stopAnimating()
        let position = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        latLong(coordinate: position)

        myMaps.camera = GMSCameraPosition(target: position, zoom: 18, bearing: 0, viewingAngle: 0)
        let location: CLLocation = locations.last!
            let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)
            if myMaps.isHidden {
                myMaps.isHidden = false
                myMaps.camera = camera
            } else {
                myMaps.animate(to: camera)
            }
    }
    
    @objc private func panHandler(_ pan : UIPanGestureRecognizer){
        if pan.state == .began{
            
            
        }else if pan.state == .ended{
                let mapSize = self.myMaps.frame.size
                let point = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
                let newCoordinate = self.myMaps.projection.coordinate(for: point)
                print(newCoordinate)
                self.latLong(coordinate: newCoordinate)
                self.startCardHeight = 200

            }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
          fatalError()
        }
        switch status {
            case .restricted:
              print("Location access was restricted.")
            case .denied:
              print("User denied access to location.")
              // Display the map using the default location.
              myMaps.isHidden = false
            case .notDetermined:
              print("Location status not determined.")
            case .authorizedAlways: fallthrough
            case .authorizedWhenInUse:
              print("Location status is OK.")
            @unknown default:
              fatalError()
            }
          }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    func latLong(coordinate: CLLocationCoordinate2D){
        geoCoder.reverseGeocodeCoordinate(coordinate) {[weak self] response, error in
            
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            guard let placemark = response?.firstResult() else {return}
            self?.selectedLocation.onNext(Location(Title: placemark.thoroughfare, latitude: coordinate.latitude, longitude: coordinate.longitude))
        }

    }
}
extension MapViewController: SearchControllerDelegate {
    func placeClicked(place: GMSPlace) {
        let camera = GMSCameraPosition(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        myMaps.camera = camera
        selectedLocation.onNext(Location(Title: place.name ?? "Pin", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        searchController?.isActive = false
    }
}

extension MapViewController{
    func setupCard() {
        // Setup starting and ending card height
        endCardHeight = self.view.frame.height * 0.9
        startCardHeight = self.view.frame.height * 0.2
        
        // Add CardViewController xib to the bottom of the screen, clipping bounds so that the corners can be rounded
        
        mapDetailViewController = MapDetailViewController(nibName:"MapDetail", bundle:nil)
        selectedLocation.bind(to: mapDetailViewController.selectedLocation).disposed(by: disposeBag)
        self.view.addSubview(mapDetailViewController.view)
        mapDetailViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - startCardHeight, width: self.view.bounds.width, height: endCardHeight)
        mapDetailViewController.view.clipsToBounds = true
        
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar

        
        // Add tap and pan recognizers
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MapViewController.handleCardPan(recognizer:)))
        
        mapDetailViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        mapDetailViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    // Handle tap gesture recognizer
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        // Animate card when tap finishes
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    // Handle pan gesture recognizer
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start animation if pan begins
            startInteractiveTransition(state: nextState, duration: 0.9)
            
        case .changed:
            // Update the translation according to the percentage completed
            let translation = recognizer.translation(in: self.mapDetailViewController.handleArea)
            var fractionComplete = translation.y / endCardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            // End animation when pan ends
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    // Animate transistion function
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        // Check if frame animator is empty
        if runningAnimations.isEmpty {
            // Create a UIViewPropertyAnimator depending on the state of the popover view
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    // If expanding set popover y to the ending height and blur background
                    self.mapDetailViewController.view.frame.origin.y = self.view.frame.height - self.endCardHeight
                case .collapsed:
                    // If collapsed set popover y to the starting height and remove background blur
                    self.mapDetailViewController.view.frame.origin.y = self.view.frame.height - self.startCardHeight
                }
            }
            
            // Complete animation frame
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            // Start animation
            frameAnimator.startAnimation()
            
            // Append animation to running animations
            runningAnimations.append(frameAnimator)
            
            // Create UIViewPropertyAnimator to round the popover view corners depending on the state of the popover
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    // If the view is expanded set the corner radius to 30
                    self.mapDetailViewController.view.layer.cornerRadius = 30
                    
                case .collapsed:
                    // If the view is collapsed set the corner radius to 0
                    self.mapDetailViewController.view.layer.cornerRadius = 10
                }
            }
            
            // Start the corner radius animation
            cornerRadiusAnimator.startAnimation()
            
            // Append animation to running animations
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    // Function to start interactive animations when view is dragged
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        
        // If animation is empty start new animation
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Pause animation and update the progress to the fraction complete percentage
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // Funtion to update transition when view is dragged
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Update the fraction complete value to the current progress
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    // Function to continue an interactive transisiton
    func continueInteractiveTransition (){
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Continue the animation forwards or backwards
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
