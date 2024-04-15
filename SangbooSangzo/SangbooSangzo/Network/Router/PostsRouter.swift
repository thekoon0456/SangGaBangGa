//
//  PosterRouter.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

import Moya

struct FetchPostsqQuery: Encodable {
    let next: String?
    let limit: String?
    let productID: String?
    
    enum CodingKeys: String, CodingKey {
        case next
        case limit
        case productID = "product_id"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.next, forKey: .next)
        try container.encodeIfPresent(self.limit, forKey: .limit)
        try container.encodeIfPresent(self.productID, forKey: .productID)
    }
}

struct FetchPostsResponse: Decodable {
    let data: UploadContentResponse
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

enum PostsRouter {
    case uploadImage(query: UploadImageDatasRequest)
    case uploadContents(query: UploadContentRequest)
    case fetchContents(query: FetchPostsqQuery)
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
        case .fetchContents(query: let query):
            guard let next = query.next,
                  let limit = query.limit else {
                return "/v1/posts"
            }
            return "/v1/posts?next=\(next)&limit=\(limit)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImage:
                .post
        case .uploadContents:
                .post
        case .fetchContents:
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
        case .fetchContents:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .uploadImage:
             [HTTPHeader.contentType: HTTPHeader.multiPartFormData]
        case .uploadContents:
             [HTTPHeader.contentType: HTTPHeader.json]
        case .fetchContents:
            [:]
        }
    }
}
