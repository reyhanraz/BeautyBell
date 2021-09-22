//
//  GoogleGeocodeTest.swift
//  BeautyBellTests
//
//  Created by Reyhan Rifqi Azzami on 22/09/21.
//

import XCTest
@testable import BeautyBell

class GoogleGeocodeTest: XCTestCase {
    
//    var geoCoder: GMSGeocoder!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        geoCoder = GMSGeocoder()
//    }
//
//    override func tearDownWithError() throws {
//        geoCoder = nil
//        try super.tearDownWithError()
//    }
//
//    func test_Geocoder_findbyAddress_success() {
//        
//        geoCoder.geocodeAddressString("Monas") { placemarks, error in
//
//            guard error == nil else {
//                XCTFail(error!.localizedDescription)
//                return
//            }
//
//            guard let coordinate = placemarks?.first?.location?.coordinate else {
//                XCTFail("No coordinate"); return
//            }
//            
//            print(coordinate)
//
//            XCTAssertNotEqual(coordinate.latitude, -6.175392, accuracy: 0.001, "Latitude doesn't match")
//            XCTAssertNotEqual(coordinate.longitude, 106.827153, accuracy: 0.001, "Longitude doesn't match")
//        }
//    }
//    
//    func test_Geocoder_findbyAddress_fail() {
//        geoCoder.geocodeAddressString("Monas") { placemarks, error in
//            guard error == nil else {
//                XCTFail(error!.localizedDescription); return
//            }
//
//            guard let coordinate = placemarks?.first?.location?.coordinate else {
//                XCTFail("No coordinate"); return
//            }
//
//            XCTAssertNotEqual(coordinate.latitude, 37.3316851, accuracy: 0.001, "Latitude doesn't match")
//            XCTAssertNotEqual(coordinate.longitude, -122.0300674, accuracy: 0.001, "Longitude doesn't match")
//        }
//    }
//    
//    func test_geocode_reverse_success(){
//        let lat: Double = 37.3316851
//        let long: Double = -122.0300674
//        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
//            
//            guard error == nil else{
//                XCTFail(error!.localizedDescription)
//                return
//            }
//            guard let placemark = response?.firstResult() else {return}
//            XCTAssertEqual(placemark.lines?.first, "Infinite Loop, Cupertino, CA 95014, USA")
//            XCTAssertEqual(placemark.thoroughfare, "Infinite Loop")
//        }
//    }
//    
//    func test_geocode_reverse_fail(){
//        let lat: Double = 37.3316851
//        let long: Double = -122.0300674
//        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
//            print(coordinate)
//            
//            guard error == nil else{
//                XCTFail(error!.localizedDescription)
//                return
//            }
//            guard let placemark = response?.firstResult() else {return}
//            XCTAssertEqual(placemark.lines?.first, "Infinite Loop, Cupertino, CA 95014, USA")
//            XCTAssertEqual(placemark.thoroughfare, "Jalan Kartini")
//        }
//    }

}
