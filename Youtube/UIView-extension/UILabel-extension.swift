//
//  UILabel-extension.swift
//  UILabel-extension
//
//  Created by 陳韋綸 on 2022/5/12.
//

import Foundation
import UIKit

extension UILabel {
    
    func videoButtonTitle(textColor: UIColor, backgroundColor: UIColor, fontSize: CGFloat, weight: UIFont.Weight) {
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.text = text
        self.backgroundColor = backgroundColor
        sizeToFit()
    }
    
    func normal(text: String, textColor: UIColor, backgroundColor: UIColor, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        sizeToFit()
        return self
    }
    
    func HomeTitle() -> UILabel {
        textColor = .black
        textAlignment = .left
        font = .systemFont(ofSize: 18)
        sizeToFit()
        numberOfLines = 2
        return self
    }
    
    func HomeChannelAndPublishTimeTitle() -> UILabel {
        textColor = .gray
        textAlignment = .left
        font = .systemFont(ofSize: 14)
        sizeToFit()
        numberOfLines = 2
        return self
    }
    
    func VideoViewTitle() -> UILabel {
        textColor = .black
        textAlignment = .left
        font = .systemFont(ofSize: 18)
        sizeToFit()
        numberOfLines = 0
        return self
    }
    
    func VideoChannelName() -> UILabel {
        textColor = .black
        textAlignment = .left
        font = .systemFont(ofSize: 18)
        sizeToFit()
        return self
    }
}
