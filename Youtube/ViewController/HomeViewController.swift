//
//  ViewController.swift
//  YoutubeClone
//
//  Created by 陳韋綸 on 2022/5/12.
//

import UIKit
import PKHUD

class HomeViewController: UIViewController {

    private let titleViews = UIView()
    private let iconImage = UIImageView().fillImageView()
    private let searchButton = UIButton(type: .system).normal(systemName: "magnifyingglass", pointSize: 20)
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: HomeViewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        let colletionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colletionView.backgroundColor = .white
        colletionView.delegate = self
        colletionView.dataSource = self
        colletionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        return colletionView
    }()
    
    private var popularElement = [YoutubeSearchStruckItem]()
    private let filterTitleArray = ["熱門影片","音樂","美食","遊戲","日本文化","程式設計"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        catchPopular()
        setupBinding()
        setupLayout()
    }
    
    private func getType(type: String) {
        HUD.show(.progress, onView: view)
        YoutubeCatchData.shared.getSearch(query: type) { [weak self] result in
            switch result {
            case .success(let data):
                self?.popularElement = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    HUD.hide()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupBinding() {
        searchButton.addTarget(self, action: #selector(didTapSearch), for: .touchUpInside)
    }
    
    @objc private func didTapSearch() {
        let vc = SearchViewController()
        let navvc = UINavigationController(rootViewController: vc)
        navvc.modalPresentationStyle = .fullScreen
        present(navvc, animated: false, completion: nil)
    }
    
    private func setupLayout() {
        iconImage.image = UIImage(named: "youtubeIcon")
        searchButton.tintColor = .black
        
        view.addSubview(titleViews)
        view.addSubview(iconImage)
        view.addSubview(searchButton)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,width: 100, height: 50, leftPadding: 10)
        searchButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, width: 50, height: 50, rightPadding: 10)
        titleViews.anchor(top: iconImage.topAnchor, bottom: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottomPadding: -10)
        collectionView.anchor(top: titleViews.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 50)
        tableView.anchor(top: collectionView.bottomAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleViews.layer.addBorder(edge: .bottom, color: .systemGray3, thickness: 1)
    }
    
    private func catchPopular() {
        YoutubeCatchData.shared.getPopularVideos { [weak self] result in
            switch result {
            case .success(let data):
                let videoId = data.id
                let channelId = data.snippet.channelId
                let channelTitle = data.snippet.channelTitle
                let publishTime = data.snippet.publishedAt
                let title = data.snippet.title
                guard let height = data.snippet.thumbnails.high?.height,
                      let width = data.snippet.thumbnails.high?.width,
                      let url = data.snippet.thumbnails.high?.url else {
                          return
                      }
                self?.popularElement.append(
                    YoutubeSearchStruckItem(
                        id: YoutubeSearchStruckId(
                            videoId: videoId), snippet: YoutubeSearchStruckSnippet(
                                channelId: channelId, channelTitle: channelTitle, publishTime: publishTime, thumbnails: YoutubeSearchStruckThumbnails(
                                    medium: nil, high: YoutubeSearchStruckImageInfo(
                                        height: height, width: width, url: url), default: nil), title: title
                            )
                    )
                )
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize()
        let textFont = UIFont.systemFont(ofSize: 20)
        let textString = filterTitleArray[indexPath.row]
        let textMaxSize = CGSize(width: 240, height: CGFloat(MAXFLOAT))
        let textLabelSize = self.textSize(text: textString, font: textFont, maxSize: textMaxSize)
        cellSize.width = textLabelSize.width + 20
        cellSize.height = textLabelSize.height + 10
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(labelText: filterTitleArray[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func textSize(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
}

extension HomeViewController: HomeCollectionViewCellDelegate {
    
    func homeCollectionViewCellButton(_ title: String) {
        getType(type: title)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularElement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewTableViewCell.identifier, for: indexPath) as? HomeViewTableViewCell else {
            return UITableViewCell()
        }
        let videoImageString = popularElement[indexPath.row].snippet.thumbnails.high?.url ?? ""
        let videoTitle = popularElement[indexPath.row].snippet.title
        let channelID = popularElement[indexPath.row].snippet.channelId
        let channelTitle = popularElement[indexPath.row].snippet.channelTitle
        let videoPublishTime = popularElement[indexPath.row].snippet.publishTime
        let videoID = popularElement[indexPath.row].id.videoId
        cell.configure(videoImageString: videoImageString, videoTitle: videoTitle, channelID: channelID, channelTitle: channelTitle, videoPublishTime: videoPublishTime, videoID: videoID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = VideoViewController(searchElement: popularElement[indexPath.row])
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
    }
}

extension HomeViewController: VideoViewControllerDelegate {
    
    func videoViewControllerBackToChannelView(info: YoutubeChannelStruckItem) {
        DispatchQueue.main.async {
            let vc = ChannelInfoViewController(info: info)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

