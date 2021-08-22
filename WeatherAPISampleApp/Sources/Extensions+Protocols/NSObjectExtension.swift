//
//  NSObjectExtension.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
