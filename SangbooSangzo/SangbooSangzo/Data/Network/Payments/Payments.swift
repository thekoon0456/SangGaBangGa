//
//  Payments.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 5/5/24.
//

import Foundation
import UIKit
import WebKit

import iamport_ios

enum SSPaymentsConst {
    static let inipay = "INIpayTest"
    static let pg = PG.html5_inicis.makePgRawName(pgId: "INIpayTest")
    static let merchantUID = "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))"
    static let appScheme = "SangbooSangzo"
    static let buyerName = "김덕훈"
    static let userCode = "imp57573124"
}

final class Payments {
    
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
    
    func requestPayment() {
        let payment = createPaymentData()
        
        Iamport
            .shared
            .paymentWebView(
                webViewMode: wkWebView,
                userCode: SSPaymentsConst.userCode,
                payment: payment
            ) { [weak self] iamportResponse in
                guard let self,
                let response = iamportResponse else { return }
                if response.success == true {
                    //포트원 고유 결제 번호
                    let uid = response.imp_uid
                    //postID
                    //productName
                    //price
                    
                } else {
                    // MARK: - Coordinator toast 띄우기
                }
            }
    }
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
    }()
}
