//
//  DesignableImageView.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import UIKit

@IBDesignable
class DesignableImageView: UIImageView {

    // MARK: - Properties
    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet { layer.borderColor = borderColor.cgColor }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet { layer.borderWidth = borderWidth }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
}
