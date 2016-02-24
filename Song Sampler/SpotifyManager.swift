//
//  SpotifyManager.swift
//  Song Sampler
//
//  Created by Bryan Porter on 2/21/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import Foundation

class SpotifyManager {
    
    static let spotifyBaseAPI = "https://api.spotify.com/v1/search?&type=track&limit=50&q="
    
    static func search(query: String, completion: (tracks: [SpotifyTrack]) -> Void) {
        guard let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(
            .URLHostAllowedCharacterSet()),
            let url = NSURL(string: spotifyBaseAPI + escapedQuery)
            else {
                return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data, response, error) in
            
            if error != nil {
                print("Error: \(error!.code.description)")
                return
            }
            
            var json: [String: AnyObject]
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
            } catch {
                return
            }
            
            let tracks = parseTracksFrom(json)
            completion(tracks: tracks)
        }
        task.resume()
    }
    
    static func parseTracksFrom(json: [String: AnyObject]) -> [SpotifyTrack] {
        var tracks = [SpotifyTrack]()
        guard let jsonTracks = json["tracks"] as? [String: AnyObject],
            let jsonItems = jsonTracks["items"] as? [[String: AnyObject]]
            else {
                return tracks
        }
        
        for jsonItem in jsonItems {
            tracks.append(SpotifyTrack(itemJSON: jsonItem))
        }
        return tracks
    }
    
}