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
    
    case emailValidation(email: String)
    case emailValidationFail(email: String)
    case emailFormValidationFail
    
    case uploadSuccess
    case uploadFail
    
    case wrongAddress
    
    var message: String {
        switch self {
        case .joinSueecss:
            "회원가입에 성공했습니다."
        case .loginSuccess:
            "로그인에 성공했습니다"
        case .loginFail:
            "유효하지 않은 회원정보입니다. 회원가입을 진행해주세요."
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
        }
    }
}


