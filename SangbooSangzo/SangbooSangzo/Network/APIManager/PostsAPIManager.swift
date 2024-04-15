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
    
    let provider = MoyaProvider<PostsRouter>(session: Session(interceptor: TokenInterceptor()))
    
    func uploadImages(query: UploadImageDatasRequest) -> Single<UploadImageResponse> {
        provider.rx.request(.uploadImage(query: query))
            .map(UploadImageResponse.self)
            .catch { error -> Single<UploadImageResponse> in
                print("uploadImages 에러 발생: \(error)")
                throw error
            }
    }
    
    func uploadContents(images: [String], query: UploadContentRequest) -> Single<UploadContentResponse> {
        provider.rx.request(.uploadContents(query: query))
            .map(UploadContentResponse.self)
            .catch { error -> Single<UploadContentResponse> in
                print("uploadImages 에러 발생: \(error)")
                throw error
            }
    }

//    func fetchPosts() -> Single<> {
//        provider.rx.request(.)
//        
//    }
    
}
