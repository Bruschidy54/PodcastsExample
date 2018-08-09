//
//  EpisodeCell.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/8/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            self.titleLabel.text = episode.title
            self.descriptionLabel.text = episode.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            self.pubDateLabel.text = dateFormatter.string(from: episode.pubDate)
            
            let imageUrl = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            episodeImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 2
        }
    }
    
    
    
}
