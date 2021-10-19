//
//  WeatherResponse.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

struct Weather: Decodable {
    let id: Int
    let main: MainWeather
    let description: String
}

enum MainWeather: String, Decodable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

extension MainWeather: CustomStringConvertible {
    var description: String {
        switch self {
        case .clear: return "☀"
        case .clouds: return "☁"
        case .rain: return "☂"
        }
    }
}

struct Main: Decodable {
    let temp: Float
    let feelsLike: Float
    let tempMin: Float
    let tempMax: Float
    let pressure: Int
    let humidity: Int
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Decodable {
    let speed: Float
    let deg: Int
    let gust: Float?
}

struct WeeklyResponse: Decodable {
    let city: City
    let list: [WeeklyListItem]
}

struct City: Decodable {
    let id: Int
    let name: String
    let coord: Coord
}

struct Coord: Decodable {
    let lon: Float
    let lat: Float
}

struct WeeklyListItem: Decodable {
    let temp: Temp
    let weather: [Weather]
}

struct Temp: Decodable {
    let day: Float
    let min: Float
}

struct ForecastWeatherResponse: Decodable {
    let list: [ForecastListObject]
    let city: City
}

struct ForecastListObject: Decodable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}
