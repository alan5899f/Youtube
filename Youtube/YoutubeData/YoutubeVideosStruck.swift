//
//  YoutubeVideosStruck.swift
//  YoutubeVideosStruck
//
//  Created by 陳韋綸 on 2022/5/19.
//

import Foundation

struct YoutubeVideosStruck: Codable {
    let items: [YoutubeVideosStruckItem]
}

struct YoutubeVideosStruckItem: Codable {
    let statistics: YoutubeVideosStruckStatistics
}

struct YoutubeVideosStruckStatistics: Codable {
    let commentCount: String
    let favoriteCount: String
    let likeCount: String
    let viewCount: String
}
