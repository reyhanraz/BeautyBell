//
//  ArtisanViewModel.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 22/06/21.
//

import Foundation

class ArtisanViewModel: NSObject{
    private var service : APIServices!
    private(set) var artisan : Artisan! {
        didSet {
            self.bindEmployeeViewModelToController()
        }
    }
    
    var bindEmployeeViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        self.service =  APIServices(baseURL: "https://604048b4f34cf600173c7cda.mockapi.io/api/v1/list-artisan")
        //callFuncToGetEmpData()
    }
    
//    func callFuncToGetEmpData() {
//        self.service.ge { (empData) in
//            self.empData = empData
//        }
//    }
}
