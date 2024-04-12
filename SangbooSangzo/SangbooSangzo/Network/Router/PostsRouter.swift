//
//  PosterRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

import Moya

enum PostsRouter {
    case uploadImage(query: UploadImageDatasQuery)
    case uploadContents(query: UploadContentQuery)
}

extension PostsRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .uploadImage(let query):
            "/posts/files"
        case .uploadContents(query: let query):
            "/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImage(let query):
                .post
        case .uploadContents(query: let query):
                .post
        }
    }
    
    var task: Task {
        switch self {
        case .uploadImage(let query):
            var formData: [Moya.MultipartFormData] = []
            
            let imageDatas = query.datas
            (0..<imageDatas.count).forEach {
                let data = Moya.MultipartFormData(
                    provider: .data(imageDatas[$0]),
                    name: "files",
                    fileName: "upload\($0).jpeg",
                    mimeType: "image/jpeg"
                )
                
                formData.append(data)
            }
            
            return .uploadMultipart(formData)
        case .uploadContents(query: let query):
            let params: [String: Any] = [
                "title": query.title ?? "",
                "content": query.content ?? "",
                "content1": query.content1 ?? "",
                "content2": query.content2 ?? "",
                "content3": query.content3 ?? "",
                "content4": query.content4 ?? "",
                "content5": query.content5 ?? "",
                "productID": query.productID ?? "",
                "files": query.files ?? []
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .uploadImage:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userToken.accessToken ?? "",
             HTTPHeader.contentType: HTTPHeader.multiPartFormData]
        case .uploadContents:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userToken.accessToken ?? "",
             HTTPHeader.contentType: HTTPHeader.json]
        }
    }
}
