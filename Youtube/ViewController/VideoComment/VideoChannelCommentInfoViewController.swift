//
//  VideoChannelCommentInfoViewController.swift
//  VideoChannelCommentInfoViewController
//
//  Created by 陳韋綸 on 2022/5/18.
//

import Nuke
import UIKit

class VideoChannelCommentInfoViewController: UIViewController {
    
    private let titleView = UIView()
    private let backButton = UIButton(type: .system).normal(systemName: "chevron.left", pointSize: 20)
    private let closeButton = UIButton(type: .system).normal(systemName: "xmark", pointSize: 20)
    private let channelImage = UIImageView().channelImageView(cornerRadius: 15)
    private let channelTitle = UILabel().normal(text: "", textColor: .gray, backgroundColor: .clear, fontSize: 12, weight: .regular)
    private let channelComment = UILabel().normal(text: "", textColor: .black, backgroundColor: .clear, fontSize: 14, weight: .regular)
    
    private var info: YoutubeCommentStruckCommentSnippet
    
    init(info: YoutubeCommentStruckCommentSnippet) {
        self.info = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        closeButton.tintColor = .black
        backButton.tintColor = .black
        backButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        channelTitle.numberOfLines = 2
        channelComment.numberOfLines = 0
        
        let date = DateModels.videoDate(info.publishedAt)
        let time = DateModels.dateInterval(videoPublishTime: date)
        
        Nuke.loadImage(with: info.authorProfileImageUrl, into: channelImage)
        channelTitle.text = info.authorDisplayName + " · " + time
        channelComment.text = info.textOriginal
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    @objc private func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(closeButton)
        view.addSubview(backButton)
        view.addSubview(channelImage)
        view.addSubview(channelTitle)
        view.addSubview(channelComment)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, height: 80, topPadding: 10, leftPadding: 20)
        closeButton.anchor(top: backButton.topAnchor, bottom: backButton.bottomAnchor, right: view.rightAnchor, rightPadding: 20)
        channelImage.anchor(top: backButton.bottomAnchor, left: view.leftAnchor, width: 30, height: 30, topPadding: 20, leftPadding: 20)
        channelTitle.anchor(top: channelImage.topAnchor, left: channelImage.rightAnchor, right: view.rightAnchor, leftPadding: 10, rightPadding: 20)
        channelComment.anchor(top: channelTitle.bottomAnchor, left: channelImage.rightAnchor, right: view.rightAnchor, topPadding: 10, leftPadding: 10, rightPadding: 20)
        titleView.anchor(top: view.topAnchor, bottom: backButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleView.layer.addBorder(edge: .bottom, color: .systemGray3, thickness: 1)
    }
}
