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
    var dataParser: DataParser {
        return DecodableDataParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        let statusCode = urlResponse.statusCode
        guard case (200 ..< 300) = statusCode else {
            let json = JSON(object)
            guard let message = json["message"].string else {
                throw ResponseError.unexpectedObject(object)
            }
            throw APIError(message: message, responseObject: object)
        }
        return object
    }
}

