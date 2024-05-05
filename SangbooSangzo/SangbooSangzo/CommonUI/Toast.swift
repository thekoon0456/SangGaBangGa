//
//  Toast.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/16/24.
//

import UIKit

enum Toast: Equatable {
    case joinSueecss
    case loginSuccess
    case loginFail
    case updateUserData
    
    case emailValidation(email: String)
    case emailValidationFail(email: String)
    case emailFormValidationFail
    
    case uploadSuccess
    case uploadFail
    
    case wrongAddress
    
    case paymentsSuccess(name: String, price: Int)
    case paymentsFail
    
    case networkError
    case networkResume
    
    var message: String {
        switch self {
        case .joinSueecss:
            "회원가입에 성공했습니다"
        case .loginSuccess:
            "로그인에 성공했습니다"
        case .loginFail:
            "유효하지 않은 회원정보입니다. 회원가입을 진행해주세요"
        case .updateUserData:
            "회원정보 수정을 완료했습니다"
        case .emailValidation(let email):
            "\(email)은 사용 가능합니다"
        case .emailValidationFail(let email):
            "\(email)은 이미 가입된 이메일입니다"
        case .emailFormValidationFail:
            "올바른 이메일 형식을 입력해주세요"
        case .uploadSuccess:
            "게시글 업로드에 성공했습니다"
        case .uploadFail:
            "게시글 업로드에 실패했습니다. 다시 시도해주세요"
        case .wrongAddress:
            "유효하지 않은 주소입니다. 다시 검색해주세요"
        case .paymentsSuccess(let name, let price):
            "\(name)의 계약금 \(price)원이 입금되었습니다"
        case .paymentsFail:
            "결제 오류가 발생했습니다. 잠시 후 다시 시도해주세요"
        case .networkError:
            "네트워크 오류가 발생했습니다. 연결을 확인해주세요"
        case .networkResume:
            "네트워크가 정상적으로 연결되었습니다"
        }
    }
}


