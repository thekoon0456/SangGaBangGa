//
//  TokenInterceptor.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//
import os
import Foundation
import UIKit

import Alamofire
import Moya
import RxSwift

final class TokenInterceptor: RequestInterceptor {
    
    static let errorSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(APIKey.baseURL) == true,
              let accessToken = UserDefaultsManager.shared.userData.accessToken,
              let refreshToken = UserDefaultsManager.shared.userData.refreshToken else {
            completion(.success(urlRequest))
            return
        }
        
        UserDefaultsManager.shared.userData.accessToken = accessToken
        UserDefaultsManager.shared.userData.refreshToken = refreshToken
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("retry")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 419 //엑세스 토큰 만료
        else {
            //login화면으로
            TokenInterceptor.errorSubject.onNext(())
            completion(.doNotRetryWithError(error))
            return
        }
        
        UserAPIManager.shared.refreshToken()
            .subscribe { response in
                print("refreshToken", response.accessToken)
                UserDefaultsManager.shared.userData.accessToken = response.accessToken
            }
            .disposed(by: disposeBag)
    }
}
