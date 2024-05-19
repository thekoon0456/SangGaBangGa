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
    
    private let paymentsRepository: PaymentsRepository
    
    init(paymentsRepository: PaymentsRepository) {
        self.paymentsRepository = paymentsRepository
    }
    
    func validation(request: PaymentsRequest) -> Single<PaymentsValidationEntity> {
        paymentsRepository.validation(request: request)
    }
    
    func readMyPayments() -> Single<[PaymentsDataEntity]> {
        paymentsRepository.readMyPayments()
    }
}
