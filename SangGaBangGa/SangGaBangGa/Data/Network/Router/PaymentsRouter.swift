//
//  PaymentsRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation

import Moya

enum PaymentsRouter {
    case validation(request: PaymentsRequest)
    case me
}

extension PaymentsRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .validation:
            "/v1/payments/validation"
        case .me:
            "/v1/payments/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .validation:
                .post
        case .me:
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .validation(let request):
            let params: [String: Any] = [
                "imp_uid": request.impUID,
                "post_id": request.postID,
                "productName": request.productName,
                "price": request.price,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .me:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .validation, .me:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}

