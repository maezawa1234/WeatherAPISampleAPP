//
//  UserDefaultsService.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/24.
//

import Foundation

protocol DataStoreServiceProtocol: AnyObject {
    var searchWordList: [String] { get set }
    // Example
    var userName: String? { get set }
    var MessagesByRoomIdDictionary: [String : [Message]] { get set }
    var message: Message? { get set }
}

final class DataStoreService: DataStoreServiceProtocol {
    static let shared: DataStoreServiceProtocol = DataStoreService()
    private init() {}
    
    private let dataStore = UserDefaults.standard
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    private enum Key: String {
        case searchWordList = "search_word_list"
        case userName = "user_name"
        case dictionary = "dictionary"
        case message = "message"
    }
    
    var searchWordList: [String] {
        get { return object(forKey: .searchWordList) ?? [] }
        set { set(newValue, forKey: .searchWordList) }
    }
    
    var userName: String? {
        get { return object(forKey: .userName) }
        set { set(newValue, forKey: .userName) }
    }
    var MessagesByRoomIdDictionary: [String : [Message]] {
        get { return decodableObject(forKey: .dictionary) ?? [:] }
        set { setEncodable(newValue, forKey: .dictionary) }
    }
    var message: Message? {
        get { return decodableObject(forKey: .message) }
        set { setEncodable(newValue, forKey: .message) }
    }
}

private extension DataStoreService {
    private func object<T>(forKey key: Key) -> T? {
        return dataStore.object(forKey: key.rawValue) as? T
    }
    private func decodableObject<T: Decodable>(forKey key: Key) -> T? {
        guard let data = dataStore.data(forKey: key.rawValue) else { return nil }
        return try? jsonDecoder.decode(T.self, from: data)
    }

    private func set(_ object: Any?, forKey key: Key) {
        dataStore.set(object, forKey: key.rawValue)
        dataStore.synchronize()
    }
    
    private func setEncodable<T: Encodable>(_ object: T?, forKey key: Key) {
        guard let object = object else {
            set(nil, forKey: key)
            return
        }
        let data = try? jsonEncoder.encode(object)
        dataStore.set(data, forKey: key.rawValue)
        dataStore.synchronize()
    }
}

struct Message: Codable {
    let timestamp: Date
    let text: String
}

