//
//  CALayer-extension.swift
//  CALayer-extension
//
//  Created by 陳韋綸 on 2022/5/15.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let borders = CALayer()
        
        switch edge {
        case .top:
            borders.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            borders.frame = CGRect(x: 0, y: frame.height-thickness, width: frame.width, height: thickness)
        case .left:
            borders.frame = CGRect(x: 0, y: 0+thickness, width: thickness, height: frame.height-thickness*2)
        case .right:
            borders.frame = CGRect(x: frame.width-thickness, y: 0, width: thickness, height: frame.height-thickness*2)
        default:
            break
        }
        
        borders.backgroundColor = color.cgColor
        self.addSublayer(borders)
    }
}
