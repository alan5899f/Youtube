//
//  UIImageView-extension'.swift
//  UIImageView-extension'
//
//  Created by 陳韋綸 on 2022/5/12.
//

import Foundation
import UIKit

extension UIImageView {
    
    func fillImageView() -> UIImageView {
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        return self
    }
    
    func channelImageView(cornerRadius: CGFloat) -> UIImageView {
        contentMode = .scaleAspectFill
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        return self
    }
    
    func systemImage(systemImageName: String, contentMode: ContentMode, pointSize: CGFloat) -> UIImageView {
        image = UIImage(systemName: systemImageName)?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: pointSize))
        self.contentMode = contentMode
        return self
    }
    
    func videoButtonSystemImage(contentMode: ContentMode) {
        self.contentMode = contentMode
    }
}
