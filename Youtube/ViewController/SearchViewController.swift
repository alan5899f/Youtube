//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by 陳韋綸 on 2022/5/20.
//

import PKHUD
import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {

    private let backButton = UIButton(type: .system).normal(systemName: "chevron.left", pointSize: 20)
    private let searchBar = UISearchBar()
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: HomeViewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var searchElement = [YoutubeSearchStruckItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        setupLayout()
        setupBinding()
    }
    
    private func setupBinding() {
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }
    
    @objc private func didTapBack() {
        dismiss(animated: false, completion: nil)
    }
    
    private func setupLayout() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchBar.searchTextField.placeholder = "Youtube搜尋"
        backButton.tintColor = .black
        
        view.addSubview(backButton)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, width: 50, height: 50, leftPadding: 10)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: backButton.rightAnchor, right: view.rightAnchor, height: 50, rightPadding: 10)
        tableView.anchor(top: searchBar.bottomAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        HUD.show(.progress, onView: view)
        YoutubeCatchData.shared.getSearch(query: text) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchElement = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    HUD.hide()
                }
            case .failure(let error):
                print(error.localizedDescription)
                HUD.hide()
            }
        }
     }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchElement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewTableViewCell.identifier, for: indexPath) as? HomeViewTableViewCell else {
            return UITableViewCell()
        }
        let videoImageString = searchElement[indexPath.row].snippet.thumbnails.high?.url ?? ""
        let videoTitle = searchElement[indexPath.row].snippet.title
        let channelID = searchElement[indexPath.row].snippet.channelId
        let channelTitle = searchElement[indexPath.row].snippet.channelTitle
        let videoPublishTime = searchElement[indexPath.row].snippet.publishTime
        let videoID = searchElement[indexPath.row].id.videoId
        cell.configure(videoImageString: videoImageString, videoTitle: videoTitle, channelID: channelID, channelTitle: channelTitle, videoPublishTime: videoPublishTime, videoID: videoID)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = VideoViewController(searchElement: searchElement[indexPath.row])
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
    }
}

extension SearchViewController: VideoViewControllerDelegate {
    
    func videoViewControllerBackToChannelView(info: YoutubeChannelStruckItem) {
        DispatchQueue.main.async {
            let vc = ChannelInfoViewController(info: info)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
