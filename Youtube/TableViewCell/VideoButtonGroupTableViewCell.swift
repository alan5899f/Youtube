//
//  VideoButtonGroupTableViewCell.swift
//  VideoButtonGroupTableViewCell
//
//  Created by 陳韋綸 on 2022/5/15.
//

import UIKit

class VideoButtonGroupTableViewCell: UITableViewCell {

    static let identifier = "VideoButtonGroupTableViewCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewCompositionalLayout = {
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(70),
                    heightDimension: .absolute(70)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            let collection = UICollectionViewCompositionalLayout(section: section)
            return collection
        }()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoButtonGroupCollectionViewCell.self, forCellWithReuseIdentifier: VideoButtonGroupCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let buttonGroupArray = [
        ["hand.thumbsup", ""],
        ["hand.thumbsdown", "不喜歡"],
        ["bubble.left.and.bubble.right", "聊天室"],
        ["arrowshape.turn.up.right", "分享"],
        ["arrow.down.to.line", "下載"],
        ["scissors", "剪輯"],
        ["plus.square.on.square", "儲存"],
    ] 
    
    var videoID: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    func configure(videoID: String) {
//        self.likeCount = "ok"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension VideoButtonGroupTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonGroupArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoButtonGroupCollectionViewCell.identifier, for: indexPath) as? VideoButtonGroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        let buttonImageName = buttonGroupArray[indexPath.row][0]
        let buttonTitle = buttonGroupArray[indexPath.row][1]
        cell.configure(buttonImageName: buttonImageName , buttonTitle: buttonTitle, videoID: videoID ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
