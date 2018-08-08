//
//  APIService.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/6/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    
    let baseItunesSearchUrl = "https://itunes.apple.com/search"
    
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
