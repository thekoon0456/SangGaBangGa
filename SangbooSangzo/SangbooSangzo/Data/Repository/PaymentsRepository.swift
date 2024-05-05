//
//  PaymentsRepository.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation

import RxMoya
import RxSwift

protocol PaymentsAPIRepository {
    func validation(request: PaymentsRequest) -> Single<PaymentsValidationEntity>
    func readMyPayments() -> Single<[PaymentsDataEntity]>
}

final class PaymentsAPIRepositoryImpl {
    
    private let apiService = PaymentsAPIService()
    
    func validation(request: PaymentsRequest) -> Single<PaymentsValidationEntity> {
        apiService.validation(request: request)
            .map { $0.toValidationEntity }
    }
    
    func readMyPayments() -> Single<[PaymentsDataEntity]> {
        apiService.readMyPayments()
            .map { $0.data.map { $0.toPaymentsDataEntity } }
    }
}
