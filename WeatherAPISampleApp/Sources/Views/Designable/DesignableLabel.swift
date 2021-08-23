//
//  DesignableLabel.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import UIKit

@IBDesignable
class DesignableLabel: UILabel {

    // MARK: - Properties
    @IBInspectable var borderColor: UIColor = .clear {
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
    @IBInspectable var layerShadowOffset: CGSize = .zero {
        didSet { layer.shadowOffset = layerShadowOffset }
    }
    @IBInspectable var layerShadowOpacity: Float = 0 {
        didSet { layer.shadowOpacity = layerShadowOpacity }
    }
    @IBInspectable var layerShadowColor: UIColor = .clear {
        didSet { layer.shadowColor = layerShadowColor.cgColor }
    }
    @IBInspectable var layerShadowRadius: CGFloat = 0 {
        didSet { layer.shadowRadius = layerShadowRadius }
    }
}

