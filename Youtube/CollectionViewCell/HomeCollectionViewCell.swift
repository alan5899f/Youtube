//
//  HomeCollectionViewCell.swift
//  HomeCollectionViewCell
//
//  Created by 陳韋綸 on 2022/5/22.
//

import Foundation
import UIKit

protocol HomeCollectionViewCellDelegate: AnyObject {
    func homeCollectionViewCellButton(_ title: String)
}

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
    weak var delegate: HomeCollectionViewCellDelegate?
    
    public let button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBinding()
        setupLayout()
    }
    
    private func setupBinding() {
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc private func didTapButton() {
        guard let title = button.currentTitle else {
            print("errorTitle")
            return
        }
        delegate?.homeCollectionViewCellButton(title)
    }
    
    private func setupLayout() {
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .systemGray6
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = height/2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        contentView.addSubview(button)
        button.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    func configure(labelText: String) {
        button.setTitle(labelText, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.setTitle(nil, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
