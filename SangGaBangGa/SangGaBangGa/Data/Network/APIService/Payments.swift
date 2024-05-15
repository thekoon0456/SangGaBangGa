//
//  Payments.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import UIKit

import iamport_ios
import RxSwift

enum SSPaymentsConst {
    static let inipay = "INIpayTest"
    static let pg = PG.html5_inicis.makePgRawName(pgId: "INIpayTest")
    static let merchantUID = "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))"
    static let appScheme = "SangbooSangzo"
    static let buyerName = "김덕훈"
    static let userCode = "imp57573124"
}

final class PaymentsService {
    
    //결제데이터 생성
    func createPaymentData(
        price: Int = 100,
        produceName: String = "계약금 입금",
        buyerName: String = SSPaymentsConst.buyerName
    ) -> IamportPayment {
        let display = CardQuota()
        display.card_quota = []
        
        return IamportPayment(
            pg: SSPaymentsConst.pg,
            merchant_uid: SSPaymentsConst.merchantUID,
            amount: String(price)).then {
                $0.pay_method = PayMethod.card.rawValue
                $0.name = produceName
                $0.buyer_name = buyerName
                $0.app_scheme = SSPaymentsConst.appScheme
            }
    }
    
    func requestPayment(
        nav: UINavigationController,
        postID: String,
        productName: String,
        price: Int
    ) -> Observable<PaymentsRequest> {
        let payment = createPaymentData()
        
        return Observable.create { observer in
            Iamport
                .shared
                .payment(navController: nav,
                         userCode: SSPaymentsConst.userCode,
                         payment: payment
                ) { iamportResponse in
                    guard let response = iamportResponse,
                          let uid = response.imp_uid
                    else { return }
                    if response.success == true {
                        let request = PaymentsRequest(impUID: uid,
                                                      postID: postID,
                                                      productName: productName,
                                                      price: price)
                        observer.onNext(request)
                        observer.onCompleted()
                    } else {
                        // MARK: - Coordinator toast 띄우기
//                        observer.onError(Error)
                    }
                }
            
            return Disposables.create()
        }
    }
}
