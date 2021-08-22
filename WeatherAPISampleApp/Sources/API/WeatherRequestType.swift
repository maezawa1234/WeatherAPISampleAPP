//
//  WeatherRequestType.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/22.
//

import APIKit
import SwiftyJSON

protocol WeatherRequest: Request {}

extension WeatherRequest {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
}

extension WeatherRequest where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let json = JSON(object)
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
            print(json)
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
