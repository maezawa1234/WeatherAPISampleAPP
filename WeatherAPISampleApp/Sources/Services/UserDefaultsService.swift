//
//  UserDefaultsService.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/24.
//

import Foundation

protocol DataStoreServiceProtocol: AnyObject {
    var userName: String? { get set }
   
}

final class DataStoreService: DataStoreServiceProtocol {
    static let shared: DataStoreServiceProtocol = DataStoreService()
    private init() {}
    
    private let dataStore = UserDefaults.standard

    private enum Key: String {
        case userName = "user_name"
    }
    
    var lastUserName: String? {
        get { return object(forKey: .userName) }
        set { set(newValue, forKey: .userName) }
    }
}

private extension DataStoreService {
    private func object<T>(forKey key: Key) -> T? {
        return dataStore.object(forKey: key.rawValue) as? T
    }
    private func set(_ object: Any?, forKey key: Key) {
        dataStore.set(object, forKey: key.rawValue)
        dataStore.synchronize()
    }
}
