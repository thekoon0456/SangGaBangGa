//
//  PaymentUseCase.swift
//  SangGaBangGa
//
//  Created by Deokhun KIM on 5/19/24.
//

import Foundation

import RxSwift

protocol PaymentsUseCase {
    func validation(request: PaymentsRequest) -> Single<PaymentsValidationEntity>
    func readMyPayments() -> Single<[PaymentsDataEntity]>
}

final class PaymentsUseCaseImpl: PaymentsUseCase {
    
    private let paymentsAPIRepository: PaymentsAPIRepository
    
    init(paymentsAPIRepository: PaymentsAPIRepository) {
        self.paymentsAPIRepository = paymentsAPIRepository
    }
    
    func validation(request: PaymentsRequest) -> Single<PaymentsValidationEntity> {
        paymentsAPIRepository.validation(request: request)
    }
    
    func readMyPayments() -> Single<[PaymentsDataEntity]> {
        paymentsAPIRepository.readMyPayments()
    }
}
