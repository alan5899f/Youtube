//
//  VideoViewTableViewCell.swift
//  VideoViewTableViewCell
//
//  Created by 陳韋綸 on 2022/5/14.
//

import UIKit

class VideoTitleContentTableViewCell: UITableViewCell {

    static let identifier = "VideoTitleContentTableViewCell"
    
    private let videoTitle = UILabel().VideoViewTitle()
    private let videoPublishTime = UILabel().HomeChannelAndPublishTimeTitle()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(videoTitle)
        contentView.addSubview(videoPublishTime)
        videoTitle.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, topPadding: 10, leftPadding: 20, rightPadding: 20)
        videoPublishTime.anchor(top: videoTitle.bottomAnchor, bottom: contentView.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, topPadding: 10, bottomPadding: 10, leftPadding: 20, rightPadding: 20)
    }
    
    func configure(videoTitle: String, videoTime: String, videoID: String) {
        YoutubeCatchData.shared.getVideo(videoID: videoID) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let date = DateModels.videoDate(videoTime)
                    let time = DateModels.dateInterval(videoPublishTime: date)
                    let int = CGFloat(Int(data.statistics.viewCount) ?? 0)
                    let viewCount = StringModels.mathToString(int: int, .normalCount)
                    self?.videoPublishTime.text = viewCount + "次觀看" + " · " + time
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.videoTitle.text = videoTitle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoTitle.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
