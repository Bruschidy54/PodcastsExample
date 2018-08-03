//
//  PodcastSearchController.swift
//  PodcastsExample
//
//  Created by Dylan Bruschi on 8/2/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let podcasts = [
    Podcast(name: "This American Life", artistName: "NPR"),
    Podcast(name: "Your Mom's House", artistName: "Tom Segura")
    ]
    
    let cellId = "cellId"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      setupSearchBar()
      setupTableView()
    }
    
    // MARK:- Setup Methods
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupTableView() {
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        let url = "https://itunes.apple.com/search?term=\(searchText)"
        Alamofire.request(url).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("Failed to contact iTunes", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            let dummyString = String(data: data, encoding: .utf8)
            print(dummyString ?? "")
        }
    }
    
    //MARK:- UITableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let podcast = self.podcasts[indexPath.row]
        
        cell.textLabel?.text = "\(podcast.name)\n\(podcast.artistName)"
        cell.textLabel?.numberOfLines = -1
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        return cell
    }
}
