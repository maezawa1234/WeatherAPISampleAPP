//
//  Get.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import RxSwift
import APIKit

class WeatherService {
    func getWeather(query: String) -> Observable<WeatherResponse> {
        let request = WeatherAPI.FetchWeatherRequest(query: query)
        return Session.shared.rx.send(request: request)
    }
}
