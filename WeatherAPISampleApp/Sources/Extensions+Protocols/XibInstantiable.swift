//
//  XibInstantiatable.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/28.
//

import UIKit

protocol XibInstantiable {
    var xibName: String { get }
    static var xibName: String { get }
}

extension XibInstantiable where Self: UIView {
    var xibName: String { return className }
    static var xibName: String { return className }
}

extension XibInstantiable where Self: UIView {
    func initWithXib() {
        let bundle = Bundle(for: type(of: self))
        let views = bundle.loadNibNamed(xibName, owner: self, options: nil)
        guard let view = views?.first as? UIView else {
            fatalError("Cannot load view from .xib file")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = view.backgroundColor
        addSubview(view)
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

@IBDesignable
class XibView: UIView, XibInstantiable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithXib()
    }
}
