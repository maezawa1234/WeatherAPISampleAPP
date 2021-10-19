//
//  UserDefaultsService.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/24.
//

import UIKit

final class CacheService {
    
    // MARK: - Singleton
    static let shared = CacheService()
    private init() {}

    private let cache = NSCache<AnyObject, AnyObject>()

    func object(forKey key: String) -> AnyObject? {
        return cache.object(forKey: key as AnyObject)
    }
    func setObject<T: AnyObject>(_ object: T, forKey key: String) {
        cache.setObject(object, forKey: key as AnyObject)
    }
}
