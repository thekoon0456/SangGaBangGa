//
//  UploadContentResponse.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

struct UploadContentResponse: Decodable {
    let postID: String?
    let productID: String?
    let title: String? //제목
    let content: String? //내용
    let content1: String? //카테고리 (공실, 카페, 음식점, 기타)
    let content2: String? //주소
    let content3: String? //위, 경도
    let content4: String? //보증금, 월세
    let content5: String? //평수
    let creator: LoginResponse?
    let files: [String]?
    let likes: [String]?
    let hashTags: [String]?
    let comments: [String]?
    
    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case productID = "product_id"
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case creator
        case files
        case likes
        case hashTags
        case comments
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postID = try container.decodeIfPresent(String.self, forKey: .postID)
        self.productID = try container.decodeIfPresent(String.self, forKey: .productID)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.content1 = try container.decodeIfPresent(String.self, forKey: .content1)
        self.content2 = try container.decodeIfPresent(String.self, forKey: .content2)
        self.content3 = try container.decodeIfPresent(String.self, forKey: .content3)
        self.content4 = try container.decodeIfPresent(String.self, forKey: .content4)
        self.content5 = try container.decodeIfPresent(String.self, forKey: .content5)
        self.creator = try container.decodeIfPresent(LoginResponse.self, forKey: .creator)
        self.files = try container.decodeIfPresent([String].self, forKey: .files)
        self.likes = try container.decodeIfPresent([String].self, forKey: .likes)
        self.hashTags = try container.decodeIfPresent([String].self, forKey: .hashTags)
        self.comments = try container.decodeIfPresent([String].self, forKey: .comments)
    }
}
