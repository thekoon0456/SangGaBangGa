//
//  PostsAPIManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

final class PostsAPIManager {
    
    static let shared = PostsAPIManager()
    
    private init() { }
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<PostsRouter>(session: Session(interceptor: TokenInterceptor()), plugins: [logger])
    
    func uploadImages(query: UploadImageDatasRequest) -> Single<UploadImageResponse> {
        provider.rx.request(.uploadImage(query: query))
            .map(UploadImageResponse.self)
    }
    
    func uploadContents(images: [String], query: UploadContentRequest) -> Single<UploadContentResponse> {
        provider.rx.request(.uploadContents(query: query))
            .map(UploadContentResponse.self)
    }

//    func fetchPosts() -> Single<> {
//        provider.rx.request(.)
//        
//    }
    
}
