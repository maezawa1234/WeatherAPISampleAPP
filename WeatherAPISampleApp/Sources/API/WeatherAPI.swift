//
//  WeatherAPI.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/22.
//

import APIKit

struct WeatherAPI {
    static let appID = "f634e6dfc8306f68fba8248535ac06f4"

    struct FetchWeatherRequest: WeatherRequest {
        typealias Response = WeatherResponse

        let query: String
        let lang: String = "ja"
        let units: String = "metric"

        let method: HTTPMethod = .get
        
        let path: String = "/weather"
        
        var parameters: Any? {
            guard !WeatherAPI.appID.isEmpty else {
                fatalError("OpenWeatherAPIリクエストのためのappIDが設定されていません.\nWeatherAPI.appID")
            }
            return [
                "q": query,
                "appid": WeatherAPI.appID,
                "lang": lang,
                "units": units
            ]
        }
    }
}
