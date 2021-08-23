//
//  WeatherAPI.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/22.
//

import APIKit

struct WeatherAPI {
    static let appID = "f634e6dfc8306f68fba8248535ac06f4"

    struct CurrentWeatherRequest: WeatherRequestType {
        typealias Response = CurrentWeatherResponse

        let query: String
        let units: String = "metric"
        let lang: String = "ja"

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
    
    struct ForecastWeatherRequest: WeatherRequestType {
        typealias Response = ForecastWeatherResponse

        let query: String
        let units: String = "metric"
        let lang: String = "ja"

        var method: HTTPMethod = .get

        var path: String = "/forecast"

        var parameters: Any? {
            return [
                "q": query,
                "units": units,
                "lang": lang,
                "appid": WeatherAPI.appID
            ]
        }
    }
}
