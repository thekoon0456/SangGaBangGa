//
//  ContentEntity.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/28/24.
//

import Foundation

struct UploadImageEntity {
    let files: [String]
}

struct ContentEntity: Hashable, Identifiable {
    let id = UUID()
    let postID: String
    let productID: String
    let title: String //제목
    let content: String //내용
    let category: String //카테고리 (공실, 카페, 음식점, 기타)
    let address: String //주소
    let coordinate: String? //위, 경도
    let price: String //보증금, 월세
    let space: String //평수
    let createdAt: String
    let creator: ProfileEntity
    let files: [String]
    let likes: [String]
    let hashTags: [String]
    let comments: [PostCommentEntity]
    
    static func defaultData() -> ContentEntity {
        ContentEntity(postID: "",
                      productID: "",
                      title: "",
                      content: "",
                      category: "",
                      address: "",
                      coordinate: "",
                      price: "",
                      space: "",
                      createdAt: "",
                      creator: ProfileEntity.defaultData(),
                      files: [],
                      likes: [],
                      hashTags: [],
                      comments: [])
    }
}
