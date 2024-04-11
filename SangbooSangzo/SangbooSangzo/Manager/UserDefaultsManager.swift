//
//  UserDefaultsManager.swift
//  SangbooSangzo
//
//  Created by Deokhun KIM on 4/10/24.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    //Token
    @UserDefault(key: UserToken.key, defaultValue: UserToken.defaultValue)
    var userToken: UserToken
    
    private init() { }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    private var key: String
    private var defaultValue: T
    //userDefault를 옵셔널로 사용한다면 defaultValue 구현안해도 됨.
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let loadedData = try? decoder.decode(T.self, from: savedData) {
                    return loadedData
                }
            }
            
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: key)
            }
        }
    }
}
