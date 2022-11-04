//
//  YoutubePopularVideosStruck.swift
//  YoutubePopularVideosStruck
//
//  Created by 陳韋綸 on 2022/5/20.
//

import Foundation

struct YoutubePopularVideosStruck: Codable {
    let items: [YoutubePopularVideosStruckItem]
}

struct YoutubePopularVideosStruckItem: Codable {
    let id: String
    let snippet: YoutubePopularVideosStruckSnippet
    let statistics: YoutubePopularVideosStruckStatistics
}

struct YoutubePopularVideosStruckStatistics: Codable {
    let commentCount: String
    let favoriteCount: String
    let likeCount: String
    let viewCount: String
}

struct YoutubePopularVideosStruckSnippet: Codable {
    let channelId: String
    let channelTitle: String
    let publishedAt: String
    let thumbnails: YoutubePopularVideosStruckThumbnails
    let title: String
}

struct YoutubePopularVideosStruckThumbnails: Codable {
    let `default`: YoutubePopularVideosStruckImageInfo?
    let high: YoutubePopularVideosStruckImageInfo?
    let medium: YoutubePopularVideosStruckImageInfo?
}

struct YoutubePopularVideosStruckImageInfo: Codable {
    let url: String
    let height: Int
    let width: Int
}
