//
//  UserToken.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/11/24.
//

import Foundation

struct UserData: Codable {
    static let key = "UserToken"
    static let defaultValue = UserData(userID: nil, accessToken: nil, refreshToken: nil)
    
    var userID: String?
    var accessToken: String?
    var refreshToken: String?
}
