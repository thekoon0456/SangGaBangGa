//
//  LoginRequest.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
    
    enum CodingKeys: CodingKey {
        case email
        case password
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.password, forKey: .password)
    }
}
