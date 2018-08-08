//
//  PodcastCell.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/8/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
}
