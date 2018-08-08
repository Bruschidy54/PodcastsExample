//
//  Podcast.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/2/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
