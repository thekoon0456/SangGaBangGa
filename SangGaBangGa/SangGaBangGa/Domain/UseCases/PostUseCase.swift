//
//  PostUseCase.swift
//  SangGaBangGa
//
//  Created by Deokhun KIM on 5/19/24.
//

import Foundation

import RxSwift

protocol PostUseCase {
    func uploadImages(query: UploadImageDatasRequest) -> Single<UploadImageEntity>
    func uploadContents(images: [String], query: UploadContentRequest) -> Single<ContentEntity>
    func readPosts(query: ReadPostsQuery) -> Single<ReadPostsEntity>
    func readPost(queryID: String) -> Single<ContentEntity>
    func fetchPost(queryID: String, request: UploadContentRequest) -> Single<ContentEntity>
    func deletePost(queryID: String)
    func readUserPosts(queryID: String, query: ReadPostsQuery) -> Single<ReadPostsEntity>
    func readHashtagPosts(query: ReadPostsQuery) -> Single<ReadPostsEntity>
}

final class PostUseCaseImpl: PostUseCase {
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    func uploadImages(query: UploadImageDatasRequest) -> Single<UploadImageEntity> {
        postRepository.uploadImages(query: query)
    }
    
    func uploadContents(images: [String], query: UploadContentRequest) -> Single<ContentEntity> {
        postRepository.uploadContents(images: images, query: query)
    }

    func readPosts(query: ReadPostsQuery) -> Single<ReadPostsEntity> {
        postRepository.readPosts(query: query)
    }
    
    func readPost(queryID: String) -> Single<ContentEntity> {
        postRepository.readPost(queryID: queryID)
    }
    
    func fetchPost(queryID: String, request: UploadContentRequest) -> Single<ContentEntity> {
        postRepository.fetchPost(queryID: queryID, request: request)
    }
    
    func deletePost(queryID: String) {
        postRepository.deletePost(queryID: queryID)
    }
    
    func readUserPosts(queryID: String, query: ReadPostsQuery) -> Single<ReadPostsEntity> {
        postRepository.readUserPosts(queryID: queryID, query: query)
    }
    
    func readHashtagPosts(query: ReadPostsQuery) -> Single<ReadPostsEntity> {
        postRepository.readHashtagPosts(query: query)
    }
}
