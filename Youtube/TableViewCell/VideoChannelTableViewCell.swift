//
//  VideoChannelTableViewCell.swift
//  VideoChannelTableViewCell
//
//  Created by 陳韋綸 on 2022/5/14.
//

import UIKit
import Nuke

class VideoChannelTableViewCell: UITableViewCell {

    static let identifier = "VideoChannelTableViewCell"
    
    private let channelImage = UIImageView().channelImageView(cornerRadius: 20)
    private let channelName = UILabel().VideoChannelName()
    private let subscriptionCountLabel = UILabel().normal(text: "", textColor: .systemGray, backgroundColor: .clear, fontSize: 14, weight: .regular)
    private let subscriptionButton = UIButton(type: .system).subscription()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(channelImage)
        contentView.addSubview(channelName)
        contentView.addSubview(subscriptionCountLabel)
        contentView.addSubview(subscriptionButton)
        channelImage.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, width: 40, height: 40, topPadding: 10, bottomPadding: 10, leftPadding: 20)
        subscriptionButton.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, width: 50, rightPadding: 10)
        
    }
    
    func configure(channelID: String, channelName: String) {
        self.channelName.text = channelName
        YoutubeCatchData.shared.getChannel(channelID: channelID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let url = data.snippet.thumbnails.high?.url
                DispatchQueue.main.async {
                    let intLister = data.statistics.subscriberCount ?? ""
                    let int = CGFloat(Int(data.statistics.subscriberCount ?? "") ?? 0)
                    if intLister == "" {
                        self.channelName.anchor(top: self.channelImage.topAnchor, bottom: self.channelImage.bottomAnchor, left: self.channelImage.rightAnchor, right: self.subscriptionButton.leftAnchor, leftPadding: 10, rightPadding: 10)
                        self.subscriptionCountLabel.text = nil
                    }
                    else {
                        self.subscriptionCountLabel.anchor(top: self.channelName.bottomAnchor, bottom: self.channelImage.bottomAnchor, left: self.channelName.leftAnchor)
                        self.channelName.anchor(top: self.channelImage.topAnchor, left: self.channelImage.rightAnchor, right: self.subscriptionButton.leftAnchor, leftPadding: 10, rightPadding: 10)
                        let subscriptionCount = StringModels.mathToString(int: int, .channelCount)
                        self.subscriptionCountLabel.text = subscriptionCount + "位訂閱者"
                    }
                    Nuke.loadImage(with: url!, into: self.channelImage)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        channelImage.image = nil
        channelName.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.addBorder(edge: .top, color: .systemGray3, thickness: 1)
        layer.addBorder(edge: .bottom, color: .systemGray3, thickness: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}


