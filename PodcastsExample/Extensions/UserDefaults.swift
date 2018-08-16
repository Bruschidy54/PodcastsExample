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
    static let downloadedEpisodesKey = "downloadedEpisodesKey"
    
    func deleteEpisode(episode: Episode) {
        let savedEpisodes = downloadedEpisodes()
        let filteredEpisodes = savedEpisodes.filter { (e) -> Bool in
            // you should use episode.collectionId to be safer with deletes
            return e.title != episode.title
        }
        
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    
    func downloadEpisode(episode: Episode) {
        
        do {
        var episodes = downloadedEpisodes()
        episodes.append(episode)
        let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    
    func downloadedEpisodes() -> [Episode] {
        
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        do {
        let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let decodedErr{
            print("Failed to decode episodes:", decodedErr)
        }
        return []
    }
    
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
