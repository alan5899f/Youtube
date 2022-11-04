//
//  VideoCommentTableViewCell.swift
//  VideoCommentTableViewCell
//
//  Created by 陳韋綸 on 2022/5/16.
//

import Nuke
import UIKit

class VideoCommentTableViewCell: UITableViewCell {
    
    static let identifier = "VideoCommentTableViewCell"
    
    private let commentLabel = UILabel().normal(text: "評論", textColor: .black, backgroundColor: .clear, fontSize: 16, weight: .regular)
    
    private let channelImage = UIImageView().channelImageView(cornerRadius: 15)
    private let channelComment = UILabel().normal(text: "", textColor: .black, backgroundColor: .clear, fontSize: 14, weight: .regular)
    private let arrowImage = UIImageView().systemImage(systemImageName: "arrow.up.and.down", contentMode: .scaleAspectFill, pointSize: 10)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        arrowImage.tintColor = .black
        channelComment.numberOfLines = 2
    }
    
    func configure(channelImageID: String, channelComment: String, commentCount: Int) {
        self.commentLabel.text = "評論" + "  \(commentCount)" 
        self.channelComment.text = channelComment
        Nuke.loadImage(with: channelImageID, into: self.channelImage)
    }
    
    private func setupLayout() {
        contentView.addSubview(commentLabel)
        contentView.addSubview(channelImage)
        contentView.addSubview(channelComment)
        contentView.addSubview(arrowImage)
        commentLabel.anchor(top: contentView.topAnchor, left: contentView.leftAnchor , right: contentView.rightAnchor, topPadding: 15, leftPadding: 20, rightPadding: 20)
        channelImage.anchor(top: commentLabel.bottomAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, width: 30, height: 30, topPadding: 10, bottomPadding: 20, leftPadding: 20)
        channelComment.anchor(top: channelImage.topAnchor, left: channelImage.rightAnchor, right: contentView.rightAnchor, leftPadding: 20, rightPadding: 20)
        arrowImage.anchor(top: contentView.topAnchor, right: contentView.rightAnchor, width: 15, height: 15, topPadding: 15, rightPadding: 15)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

