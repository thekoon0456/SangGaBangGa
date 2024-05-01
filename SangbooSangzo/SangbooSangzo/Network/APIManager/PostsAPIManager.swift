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
    
    private let disposeBag = DisposeBag()
    
    let logger = NetworkLoggerPlugin()
    lazy var provider = MoyaProvider<PostsRouter>(session: Session(interceptor: TokenInterceptor()),
                                                  plugins: [logger])
    
    func uploadImages(query: UploadImageDatasRequest) -> Single<UploadImageResponse> {
        provider.rx.request(.uploadImage(query: query))
            .map(UploadImageResponse.self)
    }
    
    func uploadContents(images: [String], query: UploadContentRequest) -> Single<UploadContentResponse> {
        provider.rx.request(.uploadContents(files: images, query: query))
            .map(UploadContentResponse.self)
    }

    func readPosts(query: ReadPostsQuery) -> Single<ReadPostsResponse> {
        provider.rx.request(.readPosts(query: query))
            .map(ReadPostsResponse.self)
    }
    
    func readPost(queryID: String) -> Single<UploadContentResponse> {
        provider.rx.request(.readPost(queryID: queryID))
            .map(UploadContentResponse.self)
    }
    
    func fetchPost(queryID: String, request: UploadContentRequest) -> Single<UploadContentResponse> {
        provider.rx.request(.fetchPost(queryID: queryID, request: request))
            .map(UploadContentResponse.self)
    }
    
    func deletePost(queryID: String) {
        provider
            .rx
            .request(.deletePost(queryID: queryID))
            .subscribe { result in
            switch result {
            case .success:
                print("삭제 성공")
            case .failure(let error):
                print("삭제 실패")
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func readUserPosts(queryID: String, query: ReadPostsQuery) -> Single<ReadPostsResponse> {
        provider.rx.request(.readUserPosts(queryID: queryID, query: query))
            .map(ReadPostsResponse.self)
    }
}
