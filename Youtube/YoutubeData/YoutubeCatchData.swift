//
//  CatchData.swift
//  CatchData
//
//  Created by 陳韋綸 on 2022/5/12.
//

import Foundation

struct Constants {
    // AIzaSyCc8TsFsAAzAxSSUyEMVuRrxlckGQ5KKgc
    // AIzaSyCPY4TH3eXgOX0QI0lQXPTVj1BuKBKIAu8
    static let youtubeAPI_KEY = "AIzaSyCc8TsFsAAzAxSSUyEMVuRrxlckGQ5KKgc"
    static let youtubeChannelURL = "https://youtube.googleapis.com/youtube/v3/channels"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    static let youtubePlaylistURL = "https://www.googleapis.com/youtube/v3/playlistItems"
    static let youtubeCommentURL = "https://www.googleapis.com/youtube/v3/commentThreads"
    static let youtubeVideosURL = "https://www.googleapis.com/youtube/v3/videos"
}

enum YoutubeCatchDataError: Error {
    case getSearch
    case getChannel
    case getComment
    case getPlaylist
    case getVideos
    case getChart
}

class YoutubeCatchData {
    let resultMax = 20
    static let shared = YoutubeCatchData()
    
    func getVideo(videoID: String, completion: @escaping (Result<YoutubeVideosStruckItem, Error>) -> Void) {
        guard let query = videoID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        guard let url = URL(string: "\(Constants.youtubeVideosURL)?part=snippet,statistics&id=\(query)&key=\(Constants.youtubeAPI_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let printJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(printJson)
                let results = try JSONDecoder().decode(YoutubeVideosStruck.self, from: data)
                completion(.success(results.items[0]))
            }
            catch {
                completion(.failure(YoutubeCatchDataError.getVideos))
            }
        }
        task.resume()
    }
    
    func getPopularVideos(completion: @escaping (Result<YoutubePopularVideosStruckItem, Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.youtubeVideosURL)?part=snippet,statistics&chart=mostPopular&key=\(Constants.youtubeAPI_KEY)&maxResults=\(resultMax)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let printJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(printJson)
                let results = try JSONDecoder().decode(YoutubePopularVideosStruck.self, from: data)
                _ = results.items.map { data in
                    completion(.success(data))
                }
            }
            catch {
                completion(.failure(YoutubeCatchDataError.getVideos))
            }
        }
        task.resume()
    }
    
    func getSearch(query: String, completion: @escaping (Result<[YoutubeSearchStruckItem], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        guard let url = URL(string: "\(Constants.youtubeBaseURL)part=snippet&q=\(query)&key=\(Constants.youtubeAPI_KEY)&type=video&maxResults=\(resultMax)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let printJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(printJson)
                let results = try JSONDecoder().decode(YoutubeSearchStruck.self, from: data)
                completion(.success(results.items))
            }
            catch {
                completion(.failure(YoutubeCatchDataError.getSearch))
            }
        }
        task.resume()
    }
    
    func getChannel(channelID: String, completion: @escaping (Result<YoutubeChannelStruckItem, Error>) -> Void) {
        guard let query = channelID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        guard let url = URL(string: "\(Constants.youtubeChannelURL)?part=snippet,contentDetails,statistics,brandingSettings&id=\(query)&key=\(Constants.youtubeAPI_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let printJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(printJson)
                let results = try JSONDecoder().decode(YoutubeChannelStruck.self, from: data)
                completion(.success(results.items[0]))
            }
            catch {
                completion(.failure(YoutubeCatchDataError.getChannel))
            }
        }
        task.resume()
    }
    
    func getComment(videoID: String, completion: @escaping (Result<[YoutubeCommentStruckItem], Error>) -> Void) {
        guard let query = videoID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        guard let url = URL(string: "\(Constants.youtubeCommentURL)?part=snippet,replies&videoId=\(query)&key=\(Constants.youtubeAPI_KEY)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let printJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let results = try JSONDecoder().decode(YoutubeCommentStruck.self, from: data)
                completion(.success(results.items))
            }
            catch {
                completion(.failure(YoutubeCatchDataError.getComment))
            }
        }
        task.resume()
    }
    
    func getPlaylist(uploadID: String, completion: @escaping (Result<[YoutubePlaylistStruckItem], Error>) -> Void) {
        guard let query = uploadID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }

        guard let url = URL(string: "\(Constants.youtubePlaylistURL)?part=snippet,contentDetails,status&playlistId=\(query)&key=\(Constants.youtubeAPI_KEY)&maxResults=\(resultMax)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let printJson = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(printJson)
                let results = try JSONDecoder().decode(YoutubePlaylistStruck.self, from: data)
                completion(.success(results.items))
            }
            catch {
                completion(.failure(YoutubeCatchDataError.getPlaylist))
            }
        }
        task.resume()
    }
}
