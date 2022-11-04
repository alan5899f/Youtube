//
//  VideoCommentViewController.swift
//  VideoCommentViewController
//
//  Created by 陳韋綸 on 2022/5/16.
//

import Foundation
import UIKit

class VideoCommentViewController: UIViewController {
    
    private var comments = [YoutubeCommentStruckItem]()
    private let titleView = UIView()
    private let titleString = UILabel().normal(text: "", textColor: .white, backgroundColor: .clear, fontSize: 20, weight: .regular)
    private let backButton = UIButton(type: .system).normal(systemName: "xmark", pointSize: 20)
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(VideoCommentViewTableViewCell.self, forCellReuseIdentifier: VideoCommentViewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init(comments: [YoutubeCommentStruckItem]) {
        self.comments = comments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        backButton.tintColor = .black
        view.backgroundColor = .white
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    @objc private func didTapBack() {
        dismiss(animated: true)
    }
    
    private func setupLayout() {
        let commentCount = comments.count
        let commentCountString = String(commentCount)
        let attributedTextTitle = NSMutableAttributedString(string: "評論")
        attributedTextTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 30, weight: .bold), range: NSMakeRange(0, 2))
        attributedTextTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSMakeRange(0, 2))
        let attributedTextCommentCount = NSMutableAttributedString(string: "  \(commentCount)")
        attributedTextCommentCount.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, 2+commentCountString.count))
        attributedTextTitle.append(attributedTextCommentCount)
        titleString.attributedText = attributedTextTitle
        
        view.addSubview(titleView)
        view.addSubview(tableView)
        view.addSubview(titleString)
        view.addSubview(backButton)
        
        titleString.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, height: 80, topPadding: 10, leftPadding: 20)
        backButton.anchor(top: titleString.topAnchor, bottom: titleString.bottomAnchor, right: view.rightAnchor, width: 80)
        tableView.anchor(top: titleString.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        titleView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: titleString.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleView.layer.addBorder(edge: .bottom, color: .systemGray3, thickness: 1)
    }
}

extension VideoCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoCommentViewTableViewCell.identifier, for: indexPath) as? VideoCommentViewTableViewCell else {
            return UITableViewCell()
        }
        let model = comments[indexPath.row].snippet.topLevelComment.snippet
        let channelImageUrl = model.authorProfileImageUrl
        let channelName = model.authorDisplayName
        let channelComment = model.textOriginal
        let channelPublishTime = model.publishedAt
        let likeCount = model.likeCount
        cell.configure(channelImageUrl: channelImageUrl, channelName: channelName, channelComment: channelComment, channelPublishTime: channelPublishTime, likeCount: likeCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = comments[indexPath.row].snippet.topLevelComment.snippet
        let vc = VideoChannelCommentInfoViewController(info: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
