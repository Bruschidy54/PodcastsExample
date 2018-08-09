//
//  String.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/8/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import Foundation

extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
