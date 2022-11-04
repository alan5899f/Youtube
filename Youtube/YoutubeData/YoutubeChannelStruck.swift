//
//  YoutubeChannelStruck.swift
//  YoutubeChannelStruck
//
//  Created by 陳韋綸 on 2022/5/12.
//

import Foundation

struct YoutubeChannelStruck: Codable {
    let items: [YoutubeChannelStruckItem]
}

struct YoutubeChannelStruckItem: Codable {
    let snippet: YoutubeChannelStruckSnippet
    let contentDetails: YoutubeChannelStruckContentDetails
    let statistics: YoutubeChannelStruckStatistics
    let brandingSettings: YoutubeChannelStruckBrandingSettings
}

struct YoutubeChannelStruckBrandingSettings: Codable {
    let image: YoutubeChannelStruckBrandingSettingsImage
}

struct YoutubeChannelStruckBrandingSettingsImage: Codable {
    let bannerExternalUrl: String
}

struct YoutubeChannelStruckStatistics: Codable {
    let viewCount: String
    let subscriberCount: String?
    let videoCount: String
}

struct YoutubeChannelStruckContentDetails: Codable {
    let relatedPlaylists: YoutubeChannelStruckRelatedPlaylists
}

struct YoutubeChannelStruckRelatedPlaylists: Codable {
    let uploads: String
}

struct YoutubeChannelStruckSnippet: Codable {
    let thumbnails: YoutubeChannelStruckThumbnails
    let title: String
}

struct YoutubeChannelStruckThumbnails: Codable {
    let `default`: YoutubeChannelStruckImageInfo?
    let medium: YoutubeChannelStruckImageInfo?
    let high: YoutubeChannelStruckImageInfo?
}

struct YoutubeChannelStruckImageInfo: Codable {
    let height: Int
    let width: Int
    let url: String
}
