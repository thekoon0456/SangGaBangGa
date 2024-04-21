//
//  PosterRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

import Moya

enum PostsRouter {
    case uploadImage(query: UploadImageDatasRequest)
    case uploadContents(files: [String], query: UploadContentRequest)
    case readPosts(query: ReadPostsQuery)
    case readPost(queryID: String)
    case fetchPost(queryID: String, request: UploadContentRequest)
    case deletePost(queryID: String)
    case readUserPosts(queryID: String, query: ReadPostsQuery)
}

extension PostsRouter: TargetType {
    
    var baseURL: URL {
        URL(string: APIKey.baseURL)!
    }
    
    var path: String {
        switch self {
        case .uploadImage:
            return "/v1/posts/files"
        case .uploadContents:
            return "/v1/posts"
        case .readPosts:
            return "/v1/posts"
        case .readPost(let queryID):
            return "/v1/posts/\(queryID)"
        case .fetchPost(let queryID, _):
            return "/v1/posts/\(queryID)"
        case .deletePost(queryID: let queryID):
            return "/v1/posts/\(queryID)"
        case .readUserPosts(let userID, _):
            return "/v1/posts/users/\(userID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImage:
                .post
        case .uploadContents:
                .post
        case .readPosts:
                .get
        case .readPost:
                .get
        case .fetchPost:
                .put
        case .deletePost:
                .delete
        case .readUserPosts:
                .get
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
        case .uploadContents(let files, let query):
            let params: [String: Any] = [
                "title": query.title ?? "",
                "content": query.content ?? "",
                "content1": query.content1 ?? "",
                "content2": query.content2 ?? "",
                "content3": query.content3 ?? "",
                "content4": query.content4 ?? "",
                "content5": query.content5 ?? "",
                "product_id": query.productID ?? "SangbooSangzo",
                "files": files ?? []
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .readPosts(let query): 
            let params: [String: Any] = [
                "next": query.next ?? "",
                "limit": query.limit ?? "",
                "product_id": query.productID ?? ""
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .readPost:
            return .requestPlain
        case .fetchPost(_, let request):
            let params: [String: Any] = [
                "title": request.title ?? "",
                "content": request.content ?? "",
                "content1": request.content1 ?? "",
                "content2": request.content2 ?? "",
                "content3": request.content3 ?? "",
                "content4": request.content4 ?? "",
                "content5": request.content5 ?? "",
                "product_id": request.productID ?? "",
                "files": request.files ?? []
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .deletePost:
            return .requestPlain
        case .readUserPosts(_, let readPostsQuery):
            let params: [String: Any] = [
                "next": readPostsQuery.next ?? "",
                "limit": readPostsQuery.limit ?? "",
                "product_id": readPostsQuery.productID ?? "SangbooSangzo"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .uploadImage:
             [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
              HTTPHeader.contentType: HTTPHeader.multiPartFormData,
              HTTPHeader.sesacKey: APIKey.sesacKey]
        case .uploadContents, .fetchPost:
             [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
              HTTPHeader.contentType: HTTPHeader.json,
              HTTPHeader.sesacKey: APIKey.sesacKey]
        case .readPosts, .readPost, .deletePost, .readUserPosts:
            [HTTPHeader.authorization: UserDefaultsManager.shared.userData.accessToken ?? "",
             HTTPHeader.sesacKey: APIKey.sesacKey]
        }
    }
}
