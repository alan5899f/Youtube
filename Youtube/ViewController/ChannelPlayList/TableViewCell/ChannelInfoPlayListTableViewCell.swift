//
//  ChannelInfoTableViewCell.swift
//  ChannelInfoTableViewCell
//
//  Created by 陳韋綸 on 2022/5/19.
//

import Nuke
import UIKit

class ChannelInfoPlayListTableViewCell: UITableViewCell {
    
    static let identifier = "ChannelInfoPlayListTableViewCell"
    
    private let videoImage = UIImageView().fillImageView()
    private let videoTitle = UILabel().normal(text: "", textColor: .black, backgroundColor: .clear, fontSize: 16, weight: .regular)
    private let channelTitleTime = UILabel().normal(text: "error", textColor: .systemGray, backgroundColor: .clear, fontSize: 14, weight: .regular)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        videoTitle.numberOfLines = 3
        channelTitleTime.numberOfLines = 2
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(videoImage)
        contentView.addSubview(videoTitle)
        contentView.addSubview(channelTitleTime)
        videoImage.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, width: 150, height: 100, topPadding: 5, bottomPadding: 5, leftPadding: 10)
        videoTitle.anchor(top: videoImage.topAnchor, left: videoImage.rightAnchor, right: contentView.rightAnchor, leftPadding: 10, rightPadding: 10)
        channelTitleTime.anchor(top: videoTitle.bottomAnchor, bottom: contentView.bottomAnchor, left: videoTitle.leftAnchor, right: videoTitle.rightAnchor, bottomPadding: 5)
    }
    
    func configure(videoImageUrl: String, videoTitle: String, channelTitle: String, videoPublishTime: String, videoID: String) {
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
        Nuke.loadImage(with: videoImageUrl, into: videoImage)
        self.videoTitle.text = videoTitle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoImage.image = nil
        videoTitle.text = nil
        channelTitleTime.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
