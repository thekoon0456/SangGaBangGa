//
//  ProfileRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/17/24.
//

import Foundation

import Moya

enum ProfileRouter {
    case getMyProfile
    case updateMyProfile(request: ProfileEditRequest)
    case getOtherProfile(id: String)
}

extension ProfileRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMyProfile:
            "/v1/users/me/profile"
        case .updateMyProfile:
            "/v1/users/me/profile"
        case .getOtherProfile(let id):
            "/v1/users/\(id)/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyProfile:
                .get
        case .updateMyProfile:
                .put
        case .getOtherProfile:
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyProfile, .getOtherProfile:
            return .requestPlain
        case .updateMyProfile(let request):
            
            var formData: [Moya.MultipartFormData] = []
            
            if let nick = request.nick,
               let nickData = nick.data(using: .utf8) {
                let nickFormData = MultipartFormData(provider: .data(nickData), name: "nick")
                formData.append(nickFormData)
            }
            
            if let phoneNum = request.phoneNum,
               let phoneNumData = phoneNum.data(using: .utf8) {
                let phoneNumData = MultipartFormData(provider: .data(phoneNumData), name: "phoneNum")
                formData.append(phoneNumData)
            }
            
            if let birthDay = request.birthDay,
               let birthDayData = birthDay.data(using: .utf8) {
                let birthDayData = MultipartFormData(provider: .data(birthDayData), name: "birthDay")
                formData.append(birthDayData)
            }
            
            if let imageData = request.profile {
                let imageData = Moya.MultipartFormData(
                    provider: .data(imageData),
                    name: "profile",
                    fileName: "upload\(imageData).jpeg",
                    mimeType: "image/jpeg"
                )
                formData.append(imageData)
            }
            
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getMyProfile, .updateMyProfile, .getOtherProfile:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}

