//
//  UploadImageDatasQuery.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/12/24.
//

import Foundation

struct UploadImageDatasRequest: Encodable {
    let datas: [Data]
    
    enum CodingKeys: CodingKey {
        case datas
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.datas, forKey: .datas)
    }
}
