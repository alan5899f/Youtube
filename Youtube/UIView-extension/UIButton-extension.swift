//
//  UIButton-extension.swift
//  UIButton-extension
//
//  Created by 陳韋綸 on 2022/5/15.
//

import Foundation
import UIKit

extension UIButton {
    
    func normal(systemName: String, pointSize: CGFloat) -> UIButton {
        setImage(UIImage(systemName: systemName)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: pointSize)), for: .normal)
        return self
    }
    
    func subscription() -> UIButton {
        setTitle("訂閱", for: .normal)
        setTitleColor(.red, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return self
    }
    
    func both(title: String, systemImageName: String, imagePointSize: CGFloat) -> UIButton {
        var config = UIButton.Configuration.tinted()
        var button = UIButton()
        config.subtitle = title
        config.image = UIImage(systemName: systemImageName)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: imagePointSize))
        config.imagePlacement = .top
        config.imagePadding = 10
        config.baseBackgroundColor = .clear
        button = UIButton(configuration: config, primaryAction: nil)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = tintColor
        return button
    }
}
