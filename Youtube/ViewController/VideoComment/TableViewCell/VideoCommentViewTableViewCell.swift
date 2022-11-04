//
//  VideoCommentViewTableViewCell.swift
//  VideoCommentViewTableViewCell
//
//  Created by 陳韋綸 on 2022/5/16.
//

import Nuke
import UIKit

class VideoCommentViewTableViewCell: UITableViewCell {
    
    static let identifier = "VideoCommentViewTableViewCell"
    
    private var channelImage = UIImageView().channelImageView(cornerRadius: 15)
    private var channelName = UILabel().normal(text: "", textColor: .gray, backgroundColor: .clear, fontSize: 14, weight: .regular)
    private var channelComment = UILabel().normal(text: "", textColor: .black, backgroundColor: .clear, fontSize: 16, weight: .regular)
    
    private let likeButton = UIButton(type: .system).normal(systemName: "hand.thumbsup", pointSize: 10)
    private let likeLabel = UILabel().normal(text: "", textColor: .black, backgroundColor: .clear, fontSize: 14, weight: .regular)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        channelComment.numberOfLines = 0
        likeButton.tintColor = .black
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(channelImage)
        contentView.addSubview(channelName)
        contentView.addSubview(channelComment)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeLabel)
        channelImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, width: 30, height: 30, topPadding: 20, leftPadding: 20)
        channelName.anchor(top: channelImage.topAnchor, left: channelImage.rightAnchor, right: contentView.rightAnchor, leftPadding: 10, rightPadding: 20)
        likeButton.anchor(bottom: contentView.bottomAnchor, left: channelImage.rightAnchor, width: 50, height: 50, topPadding: 10, bottomPadding: 10)
        likeLabel.anchor(top: likeButton.topAnchor, bottom: likeButton.bottomAnchor, left: likeButton.rightAnchor)
        channelComment.anchor(top: channelName.bottomAnchor, bottom: likeButton.topAnchor, left: channelImage.rightAnchor, right: contentView.rightAnchor, topPadding: 10, bottomPadding: 10, leftPadding: 10, rightPadding: 20)
    }
    
    func configure(channelImageUrl: String, channelName: String, channelComment: String, channelPublishTime: String, likeCount: Int) {
        let date = DateModels.videoDate(channelPublishTime)
        let channelPublishTime = DateModels.dateInterval(videoPublishTime: date)
        self.channelName.text = channelName + " · " + channelPublishTime
        Nuke.loadImage(with: channelImageUrl, into: self.channelImage)
        self.channelComment.text = channelComment
        self.likeLabel.text = "\(likeCount)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        channelImage.image = nil
        channelName.text = nil
        channelComment.text = nil
        likeLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
