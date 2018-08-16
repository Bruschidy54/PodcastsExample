//
//  UserDefaults.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/15/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else { return [] }
        
        return savedPodcasts
    }
    
    func deletePodcast(podcast: Podcast) {
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return }
        
        
        let podcasts = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Podcast]
        
        let filteredPodcasts = podcasts?.filter { p -> Bool in
            return p.trackName != podcast.trackName ||
                (p.trackName == podcast.trackName && p.artistName != podcast.artistName)
        }
        
        let finalData = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        
        UserDefaults.standard.set(finalData, forKey: UserDefaults.favoritedPodcastKey)
    }
}
