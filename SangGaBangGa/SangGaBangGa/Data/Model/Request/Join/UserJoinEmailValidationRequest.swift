//
//  UserJoinEmailValidationRequest.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

struct UserJoinEmailValidationRequest: Encodable {
    let email: String
    
    enum CodingKeys: CodingKey {
        case email
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.email, forKey: .email)
    }
}
