//
//  DateExtension.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import Foundation

extension Date {
    static let formatter: DateFormatter = DateFormatter()

    func toString(format: String) -> String {
        Self.formatter.dateFormat = format
        return Self.formatter.string(from: self)
    }
}
