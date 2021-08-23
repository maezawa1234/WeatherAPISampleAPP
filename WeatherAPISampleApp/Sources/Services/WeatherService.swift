//
//  Get.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import RxSwift
import APIKit

class WeatherService {
    func getCurrentWeather(query: String) -> Observable<CurrentWeatherResponse> {
        let request = WeatherAPI.CurrentWeatherRequest(query: query)
        return Session.shared.rx.send(request: request)
    }
    func getForecastFeather(query: String) -> Observable<ForecastWeatherResponse> {
        let request = WeatherAPI.ForecastWeatherRequest(query: query)
        return Session.shared.rx.send(request: request)
    }
}
