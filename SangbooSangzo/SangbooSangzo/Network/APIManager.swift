//
//  APIManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class APIManager {
    
    let provider = MoyaProvider<UserRouter>()
    
    func login(query: LoginRequest) -> Single<Response> {
        provider.rx.request(.login(query: query))
//            .retry(3)
//            .map { try JSONDecoder().decode(<#T##type: Decodable.Type##Decodable.Type#>, from: $0.data)}
    }
    
    
    
}


