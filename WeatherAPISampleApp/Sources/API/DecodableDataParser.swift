//
//  DecodableDataParser.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import Foundation
import APIKit

final class DecodableDataParser: DataParser {
    
    // bodyのデータの変換する際のタイプを指定している. (ここではJSON)
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        return data
    }
}
