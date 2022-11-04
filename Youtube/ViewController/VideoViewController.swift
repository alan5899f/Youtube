//
//  ViewController.swift
//  Youtube
//
//  Created by 陳韋綸 on 2022/5/12.
//

import UIKit
import PKHUD
import youtube_ios_player_helper

protocol VideoViewControllerDelegate: AnyObject {
    func videoViewControllerBackToChannelView(info: YoutubeChannelStruckItem)
}

class VideoViewController: UIViewController {

    private let youtubeAVPlayer: YTPlayerView = YTPlayerView()
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoTitleContentTableViewCell.self, forCellReuseIdentifier: VideoTitleContentTableViewCell.identifier)
        tableView.register(VideoButtonGroupTableViewCell.self, forCellReuseIdentifier: VideoButtonGroupTableViewCell.identifier)
        tableView.register(VideoChannelTableViewCell.self, forCellReuseIdentifier: VideoChannelTableViewCell.identifier)
        tableView.register(VideoCommentTableViewCell.self, forCellReuseIdentifier: VideoCommentTableViewCell.identifier)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    private var searchElement: YoutubeSearchStruckItem
    private var commentElement: [YoutubeCommentStruckItem]?
    weak var delegate: VideoViewControllerDelegate?
    
    init(searchElement: YoutubeSearchStruckItem) {
        self.searchElement = searchElement
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YoutubeCatchData.shared.getComment(videoID: searchElement.id.videoId) { [weak self] result in
            switch result {
            case .success(let data):
                self?.commentElement = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    HUD.hide()
                }
            case .failure(let error):
                print(error.localizedDescription)
                HUD.hide()
            }
        }
        setupLayout()
        setupBinding()
        HUD.show(.progress)
    }
    
    private func setupBinding() {
        let videoID = searchElement.id.videoId
        youtubeAVPlayer.load(withVideoId: videoID)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDownSwipe))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func didDownSwipe(gresture: UIPanGestureRecognizer) {
        let translation = gresture.translation(in: view)
        guard let view = gresture.view else { return }
        
        if gresture.state == .changed {
            self.handleChanged(translation: translation, view: view)
        }
        else if gresture.state == .ended {
            self.handleEnd(translation: translation, view: view)
        }
    }
    
    private func handleChanged(translation: CGPoint, view: UIView) {
        guard translation.y > 0 else {
            return
        }
        let rotateTranslation = CGAffineTransform(translationX: 0, y: translation.y)
        view.transform = rotateTranslation
    }
    
    private func handleEnd(translation: CGPoint, view: UIView) {
        if translation.y > view.height/3 {
            dismiss(animated: true, completion: nil)
        }
        else {
            view.transform = .identity
            view.layoutIfNeeded()
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(youtubeAVPlayer)
        view.addSubview(tableView)
        youtubeAVPlayer.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        tableView.anchor(top: youtubeAVPlayer.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                return 80
            }
        }
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTitleContentTableViewCell.identifier, for: indexPath) as? VideoTitleContentTableViewCell else {
                    return UITableViewCell()
                }
                let videoTitle = searchElement.snippet.title
                let videoTime = searchElement.snippet.publishTime
                let videoID = searchElement.id.videoId
                cell.configure(videoTitle: videoTitle, videoTime: videoTime, videoID: videoID)
                return cell
            }
            else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoButtonGroupTableViewCell.identifier, for: indexPath) as? VideoButtonGroupTableViewCell else {
                    return UITableViewCell()
                }
                let videoID = searchElement.id.videoId
                cell.videoID = videoID
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoChannelTableViewCell.identifier, for: indexPath) as? VideoChannelTableViewCell else {
                    return UITableViewCell()
                }
                let channelID = searchElement.snippet.channelId
                let channelName = searchElement.snippet.channelTitle
                cell.configure(channelID: channelID, channelName: channelName)
                return cell
            }
            else if indexPath.row == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoCommentTableViewCell.identifier, for: indexPath) as? VideoCommentTableViewCell else {
                    return UITableViewCell()
                }
 
                let topChannelImageID = commentElement?[0].snippet.topLevelComment.snippet.authorProfileImageUrl
                let topChannelComment = commentElement?[0].snippet.topLevelComment.snippet.textOriginal
                let commentCount = commentElement?.count
                cell.configure(channelImageID: topChannelImageID ?? "", channelComment: topChannelComment ?? "", commentCount: commentCount ?? 0)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                let channelID = searchElement.snippet.channelId
                YoutubeCatchData.shared.getChannel(channelID: channelID) { [weak self] result in
                    switch result {
                    case .success(let data):
                        self?.delegate?.videoViewControllerBackToChannelView(info: data)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                dismiss(animated: true, completion: nil)
            }
            else if indexPath.row == 3 {
                let vc = VideoCommentViewController(comments: commentElement ?? [])
                let navvc = UINavigationController(rootViewController: vc)
                if let sheet = navvc.sheetPresentationController {
                    sheet.detents = [.medium(), .large()]
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersGrabberVisible = true
                    sheet.preferredCornerRadius = 24
                }
                present(navvc, animated: true, completion: nil)
            }
        }
    }
}

//extension VideoViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        let vc = FilterPresentationController(presentedViewController: presented, presenting: presenting)
//        vc.frameHeight = view.height
//        vc.frameOriginY = youtubeAVPlayer.bottom
//        return vc
//    }
//}
