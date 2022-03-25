//
//  UserDefaults+Ext.swift
//  NFT-Helper
//
//  Created by sookim on 2022/03/25.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard

    var wrappedValue: T {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: "matamaskAddress", defaultValue: "")
    static var matamaskAddress: String?
    
    @UserDefault(key: "kaikasAddress", defaultValue: "")
    static var kaikasAddress: String?
}
