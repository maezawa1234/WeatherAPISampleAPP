//
//  WeatherRequestType.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/22.
//

import APIKit
import SwiftyJSON

protocol WeatherRequestType: Request {}

extension WeatherRequestType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
}

extension WeatherRequestType where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let json = JSON(object)
        print("🚀🚀 Debug: json")
        print(json)
        let decoder = JSONDecoder()
        do {
            let data = try json.rawData()
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw error
        }
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        let statusCode = urlResponse.statusCode
        if case (400 ..< 500) = statusCode {
            let json = JSON(object)
            let decoder = JSONDecoder()
            do {
                let data = try json.rawData()
                // JSONからエラーをインスタンス化
                throw try decoder.decode(WeatherAPIError.self, from: data)
            } catch {
                throw error
            }
        }
        return object
    }
}
