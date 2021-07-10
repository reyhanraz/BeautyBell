//
//  ServiceViewModel.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 24/06/21.
//

import Foundation
struct ServiceViewModel {
    let serviceName: String
    let servicePrice: String
    let serviceCaption: String
    
    init(service: Service) {
        self.serviceName = service.name
        self.servicePrice = service.price
        self.serviceCaption = service.caption
    }
}
