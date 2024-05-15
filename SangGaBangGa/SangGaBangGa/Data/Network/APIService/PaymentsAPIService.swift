//
//  PaymentsAPIService.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class PaymentsAPIService {
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<PaymentsRouter>(session: Session(interceptor: TokenInterceptor()),
                                                    plugins: [logger])
    
    func validation(request: PaymentsRequest) -> Single<PaymentsDataResponse> {
        provider.rx.request(.validation(request: request))
            .map(PaymentsDataResponse.self)
    }
    
    func readMyPayments() -> Single<PaymentsResponse> {
        provider.rx.request(.me)
            .map(PaymentsResponse.self)
    }
}
