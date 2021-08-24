//
//  UserDefaultsService.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/24.
//

import Foundation

protocol DataStoreServiceProtocol: AnyObject {
    var lastUserName: String? { get set }
    var appLastOpenedDate: Date? { get set }
    var searchWordHistories: [String] { get set }
}

final class DataStoreService: DataStoreServiceProtocol {
    static let shared: DataStoreServiceProtocol = DataStoreService()
    private init() {}
    
    private let dataStore = UserDefaults.standard

    private enum Key: String {
        case lastUserName = "last_user_name"
        case appLastOpenedDate = "app_last_opened_date"
        case searchWordHistories = "search_word_histories"
    }
    
    var lastUserName: String? {
        get { return object(forKey: .lastUserName) }
        set { set(newValue, forKey: .lastUserName) }
    }
    var appLastOpenedDate: Date? {
        get { return object(forKey: .appLastOpenedDate) }
        set { set(newValue, forKey: .appLastOpenedDate) }
    }
    var searchWordHistories: [String] {
        get { return object(forKey: .searchWordHistories) ?? [] }
        set { return set(newValue, forKey: .searchWordHistories) }
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
