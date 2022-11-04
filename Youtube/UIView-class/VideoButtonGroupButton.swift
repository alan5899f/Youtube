//
//  UIView-class.swift
//  UIView-class
//
//  Created by 陳韋綸 on 2022/5/15.
//

import Foundation
import UIKit

class VideoButtonGroupButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .systemGray3 : .white
        }
    }
    
    public let image = UIImageView()
    public let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        image.videoButtonSystemImage(contentMode: .scaleAspectFit)
        label.videoButtonTitle(textColor: .black, backgroundColor: .clear, fontSize: 15, weight: .regular)
        image.tintColor = .black
        addSubview(image)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.anchor(top: topAnchor, centerX: centerXAnchor, height: frame.height-30)
        label.anchor(top: image.bottomAnchor, centerX: centerXAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
