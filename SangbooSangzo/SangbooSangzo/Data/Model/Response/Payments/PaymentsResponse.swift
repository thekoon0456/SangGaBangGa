//
//  PaymentsResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation

struct PaymentsResponse: Decodable {
    let data: [PaymentsDataResponse]
}

struct PaymentsDataResponse: Decodable {
    let impUID: String?
    let paymentID: String?
    let buyerID: String?
    let postID: String
    let merchantUID: String?
    let productName: String
    let price: Int
    let paidAt: String?
    
    enum CodingKeys: String, CodingKey {
        case impUID = "imp_uid"
        case paymentID = "payment_id"
        case buyerID = "buyer_id"
        case postID = "post_id"
        case merchantUID = "merchant_uid"
        case productName
        case price
        case paidAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.impUID = try container.decodeIfPresent(String.self, forKey: .impUID) ?? ""
        self.paymentID = try container.decodeIfPresent(String.self, forKey: .paymentID) ?? ""
        self.buyerID = try container.decodeIfPresent(String.self, forKey: .buyerID) ?? ""
        self.postID = try container.decode(String.self, forKey: .postID)
        self.merchantUID = try container.decodeIfPresent(String.self, forKey: .merchantUID) ?? ""
        self.productName = try container.decode(String.self, forKey: .productName)
        self.price = try container.decode(Int.self, forKey: .price)
        self.paidAt = try container.decodeIfPresent(String.self, forKey: .paidAt) ?? ""
    }
    
    var toValidationEntity: PaymentsValidationEntity {
        PaymentsValidationEntity(impUID: impUID ?? "",
                                postID: postID,
                                productName: productName,
                                price: price)
    }
    
    var toPaymentsDataEntity: PaymentsDataEntity {
        PaymentsDataEntity(paymentID: paymentID ?? "",
                           buyerID: buyerID ?? "",
                           postID: postID,
                           merchantUID: merchantUID ?? "",
                           productName: productName,
                           price: price,
                           paidAt: paidAt ?? "")
    }
}
