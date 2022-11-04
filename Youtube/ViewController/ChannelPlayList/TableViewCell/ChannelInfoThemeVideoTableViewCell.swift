//
//  ChannelInfoTableViewCell.swift
//  ChannelInfoTableViewCell
//
//  Created by 陳韋綸 on 2022/5/19.
//

import Nuke
import UIKit

class ChannelInfoThemeVideoTableViewCell: UITableViewCell {
    
    static let identifier = "ChannelInfoThemeVideoTableViewCell"
    
    private let videoImage = UIImageView().fillImageView()
    private let channelImage = UIImageView().channelImageView(cornerRadius: 15)
    private let videoTitle = UILabel().normal(text: "", textColor: .black, backgroundColor: .clear, fontSize: 16, weight: .regular)
    private let channelTitleTime = UILabel().normal(text: "error", textColor: .systemGray, backgroundColor: .clear, fontSize: 14, weight: .regular)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        videoTitle.numberOfLines = 2
        channelTitleTime.numberOfLines = 2
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(videoImage)
        contentView.addSubview(channelImage)
        contentView.addSubview(videoTitle)
        contentView.addSubview(channelTitleTime)
        
        videoImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 300)
        channelImage.anchor(top: videoImage.bottomAnchor, left: contentView.leftAnchor, width: 30, height: 30, topPadding: 20, leftPadding: 20)
        videoTitle.anchor(top: channelImage.topAnchor, left: channelImage.rightAnchor, right: contentView.rightAnchor, leftPadding: 20, rightPadding: 20)
        channelTitleTime.anchor(top: videoTitle.bottomAnchor, bottom: contentView.bottomAnchor, left: videoTitle.leftAnchor, right: videoTitle.rightAnchor, bottomPadding: 20)
    }
    
    func configure(videoTitle: String, videoImageUrl: String, channelImageUrl: String, channelTitle: String, videoPublishTime: String, videoID: String) {
        Nuke.loadImage(with: videoImageUrl, into: videoImage)
        Nuke.loadImage(with: channelImageUrl, into: channelImage)
        self.videoTitle.text = videoTitle
        YoutubeCatchData.shared.getVideo(videoID: videoID) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let date = DateModels.videoDate(videoPublishTime)
                    let time = DateModels.dateInterval(videoPublishTime: date)
                    let int = CGFloat(Int(data.statistics.viewCount) ?? 0)
                    let viewCount = StringModels.mathToString(int: int, .normalCount)
                    self?.channelTitleTime.text = channelTitle + " · " + viewCount + "次觀看" + " · " + time
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoImage.image = nil
        videoTitle.text = nil
        channelImage.image = nil
        channelTitleTime.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
