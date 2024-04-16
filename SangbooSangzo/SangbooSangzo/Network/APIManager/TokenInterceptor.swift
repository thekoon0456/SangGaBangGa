//
//  TokenInterceptor.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//
import os
import Foundation

import Alamofire
import Moya
import RxSwift

final class TokenInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIKey.baseURL + "/v1/join") == false
                && urlRequest.url?.absoluteString.hasPrefix(APIKey.baseURL + "/v1/validation/email") == false
                && urlRequest.url?.absoluteString.hasPrefix(APIKey.baseURL + "/v1/users/login") == false,
              let accessToken = UserDefaultsManager.shared.userToken.accessToken,
              let refreshToken = UserDefaultsManager.shared.userToken.refreshToken else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
//        urlRequest.setValue(accessToken, forHTTPHeaderField: HTTPHeader.authorization)
//        urlRequest.setValue(APIKey.sesacKey, forHTTPHeaderField: HTTPHeader.sesacKey)
        print("adator, \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("retry")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 419
        else {
            //login화면으로
            completion(.doNotRetryWithError(error))
            return
        }
        
        UserAPIManager.shared.refreshToken()
            .subscribe { response in
                print("refreshToken", response.accessToken)
                UserDefaultsManager.shared.userToken.accessToken = response.accessToken
            }
            .disposed(by: disposeBag)
    }
}
