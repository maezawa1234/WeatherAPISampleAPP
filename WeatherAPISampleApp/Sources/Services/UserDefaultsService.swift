//
//  UserDefaultsService.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/24.
//

import Foundation

protocol DatastoreServiceProtocol: AnyObject {
    var lastUserName: String? { get set }
    var appLastOpenedDate: Date? { get set }
}

final class DataStoreService: DatastoreServiceProtocol {
    static let shared = DataStoreService()
    private init() {}
    
    private let dataStore = UserDefaults.standard

    private enum Key: String {
        case lastUserName = "last_user_name"
        case appLastOpenedDate = "app_last_opened_date"
    }
    
    var lastUserName: String? {
        get { return object(forKey: .lastUserName) }
        set { set(newValue, forKey: .lastUserName) }
    }
    var appLastOpenedDate: Date? {
        get { return object(forKey: .appLastOpenedDate) }
        set { set(newValue, forKey: .appLastOpenedDate) }
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
