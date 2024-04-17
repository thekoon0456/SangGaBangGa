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
    case updateMyProfile(imageData: Data)
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
        case .getOtherProfile(id: let id):
            "/v1/users/\(id)/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyProfile:
                .post
        case .updateMyProfile:
                .put
        case .getOtherProfile(id: let id):
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyProfile, .getOtherProfile:
            return .requestPlain
        case .updateMyProfile(let imageData):
            let data = [Moya.MultipartFormData(
                provider: .data(imageData),
                name: "files",
                fileName: "upload\(imageData).jpeg",
                mimeType: "image/jpeg"
            )]
        return .uploadMultipart(data)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getMyProfile, .updateMyProfile, .getOtherProfile:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userToken.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}
