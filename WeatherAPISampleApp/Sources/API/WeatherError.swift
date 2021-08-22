//
//  WeatherError.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import Foundation

struct WeatherAPIError: Decodable, Error {
    let message: String
}
