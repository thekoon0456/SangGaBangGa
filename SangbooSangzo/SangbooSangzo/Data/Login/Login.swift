//
//  Login.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/11/24.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let accessToken: String
    let refreshToken: String
}

struct RefreshTokenResponse: Encodable {
    let accessToken: String
}
