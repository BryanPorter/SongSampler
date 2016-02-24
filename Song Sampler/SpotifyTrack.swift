//
//  SpotifyTrack.swift
//  Song Sampler
//
//  Created by Bryan Porter on 2/21/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import Foundation

class SpotifyTrack {
    
    var title = ""
    var artist = ""
    var previewUrl = ""
    var imageUrl = ""
    
    init(itemJSON: [String: AnyObject]) {
        guard let title = itemJSON["name"] as? String
            else {
                return
        }
        self.title = title
        
        guard let artists = itemJSON["artists"] as? [[String: AnyObject]],
            let firstArtist = artists.first,
            let artist = firstArtist["name"] as? String
            else {
                return
        }
        self.artist = artist
        
        guard let previewUrl = itemJSON["preview_url"] as? String
            else {
                return
        }
        self.previewUrl = previewUrl
        
        guard let album = itemJSON["album"] as? [String: AnyObject],
            let images = album["images"] as? [[String: AnyObject]],
            let firstImage = images.last,
            let imageUrl = firstImage["url"] as? String
            else {
                return
        }
        self.imageUrl = imageUrl
    }
}
