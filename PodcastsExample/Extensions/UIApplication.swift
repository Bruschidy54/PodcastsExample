//
//  UIApplication.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/14/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
