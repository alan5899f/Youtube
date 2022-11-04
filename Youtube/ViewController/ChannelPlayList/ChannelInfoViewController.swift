//
//  ChannelInfoViewController.swift
//  ChannelInfoViewController
//
//  Created by 陳韋綸 on 2022/5/18.
//

import PKHUD
import UIKit
import Nuke
import SwiftUI

class ChannelInfoViewController: UIViewController {
    
    private var info: YoutubeChannelStruckItem
    
    private let backButton = UIButton(type: .system).normal(systemName: "chevron.left", pointSize: 20)
    private let channelBackgorundImage = UIImageView().fillImageView()
    private let channelImage = UIImageView().channelImageView(cornerRadius: 30)
    private let channelName = UILabel().normal(text: "", textColor: .black, backgroundColor: .clear, fontSize: 22, weight: .semibold)
    private let subscriptionButton = UIButton(type: .system).subscription()
    private let subscriptionCountLabel = UILabel().normal(text: "", textColor: .systemGray, backgroundColor: .clear, fontSize: 14, weight: .regular)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChannelInfoPlayListTableViewCell.self, forCellReuseIdentifier: ChannelInfoPlayListTableViewCell.identifier)
        tableView.register(ChannelInfoThemeVideoTableViewCell.self, forCellReuseIdentifier: ChannelInfoThemeVideoTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private var data = [YoutubePlaylistStruckItem]()
    private var themeData: YoutubePlaylistStruckItem?
    
    init(info: YoutubeChannelStruckItem) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        YoutubeCatchData.shared.getPlaylist(uploadID: info.contentDetails.relatedPlaylists.uploads) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                self?.themeData = data[0]
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        setupLayout()
        setupBinding()
    }
    
    private func tableViewHeader() -> UIView {
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 250))
        tableHeaderView.addSubview(channelBackgorundImage)
        tableHeaderView.addSubview(channelImage)
        tableHeaderView.addSubview(channelName)
        tableHeaderView.addSubview(subscriptionButton)
        tableHeaderView.addSubview(subscriptionCountLabel)
        channelBackgorundImage.frame = CGRect(x: 0, y: 0, width: view.width, height: 100)
        channelImage.frame = CGRect(x: view.center.x - 30, y: channelBackgorundImage.bottom + 10, width: 60, height: 60)
        channelName.frame = CGRect(x: 20, y: channelImage.bottom, width: view.width-40, height: 60)
        subscriptionButton.frame = CGRect(x: view.center.x-50, y: channelName.bottom, width: 100, height: 30)
        subscriptionCountLabel.frame = CGRect(x: 0, y: subscriptionButton.bottom, width: view.width, height: 30)
        return tableHeaderView
    }
    
    private func setupBinding() {
        tableView.tableHeaderView = tableViewHeader()
        backButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        backButton.setTitleColor(.black, for: .normal)
        backButton.tintColor = .black
        channelName.textAlignment = .center
        channelName.numberOfLines = 0
        channelImage.layer.borderWidth = 1
        channelImage.layer.borderColor = UIColor.systemGray.cgColor
        subscriptionCountLabel.textAlignment = .center
        
        backButton.setTitle(info.snippet.title, for: .normal)
        Nuke.loadImage(with: info.brandingSettings.image.bannerExternalUrl, into: channelBackgorundImage)
        Nuke.loadImage(with: info.snippet.thumbnails.high?.url, into: channelImage)
        channelName.text = info.snippet.title
        let intLister = info.statistics.subscriberCount ?? ""
        let int = CGFloat(Int(info.statistics.subscriberCount ?? "") ?? 0)
        if intLister == "" {
            subscriptionCountLabel.text = info.statistics.videoCount + "部影片"
        }
        else {
            let subscriptionCount = StringModels.mathToString(int: int, .channelCount)
            subscriptionCountLabel.text = subscriptionCount + "位訂閱者" + " · " + info.statistics.videoCount + "部影片"
        }
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(tableView)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, height: 50, topPadding: 10, leftPadding: 10)
        tableView.anchor(top: backButton.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 10)
    }

}

extension ChannelInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let title = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
            title.text = "  熱門影片"
            title.font = .systemFont(ofSize: 24, weight: .semibold)
            title.backgroundColor = .clear
            return title
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section > 0 {
            return data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelInfoThemeVideoTableViewCell.identifier, for: indexPath) as? ChannelInfoThemeVideoTableViewCell else {
                return UITableViewCell()
            }
            guard let videoTitle = themeData?.snippet.title,
                  let videoImageUrl = themeData?.snippet.thumbnails.medium?.url,
                  let videoPublishTime = themeData?.contentDetails.videoPublishedAt,
                  let channelImageUrl = info.snippet.thumbnails.high?.url,
                  let videoID = themeData?.contentDetails.videoId else {
                      return UITableViewCell()
                  }
            
            let channelTitle = info.snippet.title
            cell.configure(videoTitle: videoTitle, videoImageUrl: videoImageUrl, channelImageUrl: channelImageUrl, channelTitle: channelTitle, videoPublishTime: videoPublishTime, videoID: videoID)
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelInfoPlayListTableViewCell.identifier, for: indexPath) as? ChannelInfoPlayListTableViewCell else {
                return UITableViewCell()
            }
            let videoImageUrl = data[indexPath.row].snippet.thumbnails.medium?.url ?? ""
            let videoTitle = data[indexPath.row].snippet.title
            let videoPublishTime = data[indexPath.row].contentDetails.videoPublishedAt
            let channelTitle = info.snippet.title
            let videoID = data[indexPath.row].contentDetails.videoId
            cell.configure(videoImageUrl: videoImageUrl, videoTitle: videoTitle, channelTitle: channelTitle, videoPublishTime: videoPublishTime, videoID: videoID)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = data[indexPath.row]
        let videoId = model.contentDetails.videoId
        let channelId = model.snippet.channelId
        let channelTitle = model.snippet.channelTitle
        let publishTime = model.contentDetails.videoPublishedAt
        let height = model.snippet.thumbnails.high?.height ?? 0
        let width = model.snippet.thumbnails.high?.width ?? 0
        let url = model.snippet.thumbnails.high?.url ?? ""
        let title = model.snippet.title
        
        let vc = VideoViewController(searchElement: YoutubeSearchStruckItem(id: YoutubeSearchStruckId(videoId: videoId), snippet: YoutubeSearchStruckSnippet(channelId: channelId, channelTitle: channelTitle, publishTime: publishTime, thumbnails: YoutubeSearchStruckThumbnails(medium: nil, high: YoutubeSearchStruckImageInfo(height: height, width: width, url: url), default: nil), title: title)))
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

//extension ChannelInfoViewController: VideoViewControllerDelegate {
//
//    func videoViewControllerBackToChannelView(info: YoutubeChannelStruckItem) {
//        let vc = ChannelInfoViewController(info: info)
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
