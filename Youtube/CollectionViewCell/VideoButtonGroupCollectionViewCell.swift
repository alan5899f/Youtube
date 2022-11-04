//
//  VideoButtonGroupCollectionViewCell.swift
//  VideoButtonGroupCollectionViewCell
//
//  Created by 陳韋綸 on 2022/5/15.
//

import UIKit

class VideoButtonGroupCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VideoButtonGroupCollectionViewCell"
    
    private var button = VideoButtonGroupButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(button)
        button.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor)
    }
    
    func configure(buttonImageName: String, buttonTitle: String, videoID: String) {
        YoutubeCatchData.shared.getVideo(videoID: videoID) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if buttonTitle == "" {
                        let int = data.statistics.likeCount
                        let likeCount = StringModels.mathToString(int: CGFloat(Int(int) ?? 0), .normalCount)
                        self.button.label.text = likeCount 
                    }
                    else {
                        self.button.label.text = buttonTitle
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        button.image.image = UIImage(systemName: buttonImageName)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button.image.image = nil
        button.label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 35
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
