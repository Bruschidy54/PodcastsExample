//
//  APIService.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/6/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    static let shared = APIService()
    
    let baseItunesSearchUrl = "https://itunes.apple.com/search"
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl.toSecureHTTPS()) else { return }
        
        
        let parser = FeedParser(URL: url)
        parser?.parseAsync(result: { (result) in
            print("Successfully parse feed:", result.isSuccess)
            
            if let err = result.error {
                print("Failed to parse XML feed", err)
                return
            }
            
            guard let feed = result.rssFeed else { return }
            
            let episodes = feed.toEpisodes()
            completionHandler(episodes)
        })
    }
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let parameters = ["term" : searchText, "media" : "podcast"]
        
        Alamofire.request(baseItunesSearchUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact iTunes", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                print("Result count:", searchResult.resultCount)
                searchResult.results.forEach({ (podcast) in
                    print(podcast.artistName, podcast.trackName)
                })
                
                completionHandler(searchResult.results)

            } catch let err {
                print("Failed to decode SearchResults:", err)
            }
        }
    }
}
