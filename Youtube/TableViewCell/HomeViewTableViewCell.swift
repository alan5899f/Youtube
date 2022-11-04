//
//  HomeViewTableViewCell.swift
//  HomeViewTableViewCell
//
//  Created by 陳韋綸 on 2022/5/12.
//
import UIKit
import Nuke

class HomeViewTableViewCell: UITableViewCell {

    static let identifier = "HomeViewTableViewCell"
    
    private let videoImage = UIImageView().fillImageView()
    private let videoTitle = UILabel().HomeTitle()
    private let channelImage = UIImageView().channelImageView(cornerRadius: 15)
    private let channelTitleAndTime = UILabel().HomeChannelAndPublishTimeTitle()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(videoImage)
        contentView.addSubview(videoTitle)
        contentView.addSubview(channelImage)
        contentView.addSubview(channelTitleAndTime)

        videoImage.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, height: 300)
        channelImage.anchor(top: videoImage.bottomAnchor, left: contentView.leftAnchor, width: 30, height: 30, topPadding: 10, leftPadding: 10)
        videoTitle.anchor(top: videoImage.bottomAnchor, left: channelImage.rightAnchor, right: contentView.rightAnchor, topPadding: 10, leftPadding: 10, rightPadding: 10)
        channelTitleAndTime.anchor(top: videoTitle.bottomAnchor, bottom: contentView.bottomAnchor, left: videoTitle.leftAnchor, right: contentView.rightAnchor, height: 30, bottomPadding: 10, rightPadding: 10)
    }
    
    func configure(videoImageString: String, videoTitle: String, channelID: String, channelTitle: String, videoPublishTime: String, videoID: String) {

        YoutubeCatchData.shared.getChannel(channelID: channelID) { result in
            switch result {
            case .success(let data):
                let url = data.snippet.thumbnails.high?.url
                DispatchQueue.main.async {
                    Nuke.loadImage(with: url!, into: self.channelImage)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        YoutubeCatchData.shared.getVideo(videoID: videoID) { [weak self] result in
            switch result {
            case .success(let data):
                let date = DateModels.videoDate(videoPublishTime)
                let time = DateModels.dateInterval(videoPublishTime: date)
                let int = CGFloat(Int(data.statistics.viewCount) ?? 0)
                let viewCount = StringModels.mathToString(int: int, .normalCount)
                DispatchQueue.main.async {
                    self?.channelTitleAndTime.text = channelTitle + " · " + viewCount + "次觀看" + " · " + time
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.videoTitle.text = videoTitle
        Nuke.loadImage(with: videoImageString, into: videoImage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        videoImage.image = nil
        channelImage.image = nil
        videoTitle.text = nil
        channelTitleAndTime.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
   
}

