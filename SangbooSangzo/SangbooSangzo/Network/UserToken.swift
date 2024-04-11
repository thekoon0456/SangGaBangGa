//
//  UserToken.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/11/24.
//

import Foundation

struct UserToken: Codable {
    static let key = "UserToken"
    static let defaultValue = UserToken(accessToken: "", refreshToken: "")
    
    var accessToken: String
    var refreshToken: String
}
