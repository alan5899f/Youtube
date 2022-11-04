//
//  YoutubeCommentStruck.swift
//  YoutubeCommentStruck
//
//  Created by 陳韋綸 on 2022/5/16.
//

import Foundation

struct YoutubeCommentStruck: Codable {
    let items: [YoutubeCommentStruckItem]
}

struct YoutubeCommentStruckItem: Codable {
    let snippet: YoutubeCommentStruckSnippet
}

struct YoutubeCommentStruckSnippet: Codable {
    let topLevelComment: YoutubeCommentStruckComment
}

struct YoutubeCommentStruckComment: Codable {
    let snippet: YoutubeCommentStruckCommentSnippet
}

struct YoutubeCommentStruckCommentSnippet: Codable {
    let authorProfileImageUrl: String
    let authorDisplayName: String
    let textOriginal: String
    let publishedAt: String
    let likeCount: Int
}
