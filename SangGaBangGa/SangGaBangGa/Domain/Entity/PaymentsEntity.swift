//
//  PaymentsEntity.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation

struct PaymentsValidationEntity {
    let impUID: String
    let postID: String
    let productName: String
    let price: Int
    
    static func defaultEntity() -> PaymentsValidationEntity {
        PaymentsValidationEntity(impUID: "",
                                 postID: "",
                                 productName: "",
                                 price: 0)
    }
}

struct PaymentsDataEntity {
    let paymentID: String
    let buyerID: String
    let postID: String
    let merchantUID: String
    let productName: String
    let price: Int
    let paidAt: String
}
