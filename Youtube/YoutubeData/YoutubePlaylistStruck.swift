//
//  YoutubePlaylistStruck.swift
//  YoutubePlaylistStruck
//
//  Created by 陳韋綸 on 2022/5/19.
//

import Foundation

struct YoutubePlaylistStruck: Codable {
    let items: [YoutubePlaylistStruckItem]
}

struct YoutubePlaylistStruckItem: Codable {
    let contentDetails: YoutubePlaylistStruckContentDetails
    let snippet: YoutubePlaylistStruckSnippet
}

struct YoutubePlaylistStruckContentDetails: Codable {
    let videoId: String
    let videoPublishedAt: String
}

struct YoutubePlaylistStruckSnippet: Codable {
    let channelTitle: String
    let channelId: String
    let description: String
    let thumbnails: YoutubePlaylistStruckThumbnails
    let title: String
}

struct YoutubePlaylistStruckThumbnails: Codable {
    let `default`: YoutubePlaylistStruckImageInfo?
    let high: YoutubePlaylistStruckImageInfo?
    let maxres: YoutubePlaylistStruckImageInfo?
    let medium: YoutubePlaylistStruckImageInfo?
    let standard: YoutubePlaylistStruckImageInfo?
}

struct YoutubePlaylistStruckImageInfo: Codable {
    let height: Int
    let width: Int
    let url: String
}


