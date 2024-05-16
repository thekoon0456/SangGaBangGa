//
//  PostRepository.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/28/24.
//

import Foundation

import RxMoya
import RxSwift

protocol PostRepository {
    func uploadImages(query: UploadImageDatasRequest) -> Single<UploadImageEntity>
    func uploadContents(images: [String], query: UploadContentRequest) -> Single<ContentEntity>
    func readPosts(query: ReadPostsQuery) -> Single<ReadPostsEntity>
    func readPost(queryID: String) -> Single<ContentEntity>
    func fetchPost(queryID: String, request: UploadContentRequest) -> Single<ContentEntity>
    func deletePost(queryID: String)
    func readUserPosts(queryID: String, query: ReadPostsQuery) -> Single<ReadPostsEntity>
    func readHashtagPosts(hashtag: String, query: ReadPostsQuery) -> Single<ReadPostsEntity>
}

final class PostRepositoryImpl: PostRepository {
    
    private let apiService = PostsAPIService()
    
    func uploadImages(query: UploadImageDatasRequest) -> Single<UploadImageEntity> {
        apiService.uploadImages(query: query)
            .map { $0.toEntity }
    }
    
    func uploadContents(images: [String], query: UploadContentRequest) -> Single<ContentEntity> {
        apiService.uploadContents(images: images, query: query)
            .map { $0.toEntity }
    }

    func readPosts(query: ReadPostsQuery) -> Single<ReadPostsEntity> {
        apiService.readPosts(query: query)
            .map { $0.toEntity }
    }
    
    func readPost(queryID: String) -> Single<ContentEntity> {
        apiService.readPost(queryID: queryID)
            .map { $0.toEntity }
    }
    
    func fetchPost(queryID: String, request: UploadContentRequest) -> Single<ContentEntity> {
        apiService.fetchPost(queryID: queryID, request: request)
            .map { $0.toEntity }
    }
    
    func deletePost(queryID: String) {
        apiService.deletePost(queryID: queryID)
    }
    
    func readUserPosts(queryID: String, query: ReadPostsQuery) -> Single<ReadPostsEntity> {
        apiService.readUserPosts(queryID: queryID, query: query)
            .map { $0.toEntity }
    }
    
    func readHashtagPosts(hashtag: String, query: ReadPostsQuery) -> Single<ReadPostsEntity> {
        apiService.readHashtagPosts(hashtag: hashtag, query: query)
            .map { $0.toEntity }
    }
}
