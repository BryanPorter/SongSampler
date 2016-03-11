//
//  SavedVC.swift
//  Song Sampler
//
//  Created by Bryan Porter on 3/9/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import AVFoundation

class SavedVC : UITableViewController {
    
    var tracks : Results<RealmTrack>!
    
    @IBAction func playAll(sender: AnyObject) {
        if(tracks.endIndex == 0 && !tracks.isEmpty){
            let sTrack = SpotifyTrack(track: tracks[0])
            let url = NSURL(string: sTrack.previewUrl)
            let item = AVPlayerItem(URL: url!)
            tableItems.insert(item, atIndex: 0)
            tableData.insert(sTrack, atIndex: 0)
        } else if(tracks.endIndex > 0) {
            let currentItems = tableData.endIndex
            let incVal = currentItems/(tracks.endIndex) + 2
            var insLoc = 0
        
            for rTrack in tracks {
                let sTrack = SpotifyTrack(track: rTrack)
                let url = NSURL(string: sTrack.previewUrl)
                let item = AVPlayerItem(URL: url!)
                tableItems.insert(item, atIndex: insLoc)
                tableData.insert(sTrack, atIndex: insLoc)
                insLoc += incVal
                if(insLoc > tableData.endIndex){
                    insLoc = tableData.endIndex
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = SpotifyTrack(track: tracks[indexPath.row])
        let url = NSURL(string: track.previewUrl)
        let item = AVPlayerItem(URL: url!)
        tableItems.insert(item, atIndex: 0)
        tableData.insert(track, atIndex: 0)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        tracks = realm.objects(RealmTrack)
        
        let nib = UINib(nibName: "customCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cCell")
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        player = AVPlayer()
        player.usesExternalPlaybackWhileExternalScreenIsActive = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:customCell = tableView.dequeueReusableCellWithIdentifier("cCell", forIndexPath: indexPath) as! customCell
        
        cell.title?.text = tracks[indexPath.row].title
        cell.artist?.text = tracks[indexPath.row].artist
        
        let url = NSURL(string: tracks[indexPath.row].albumArt)
        let data = NSData(contentsOfURL: url!)
        if (data != nil){
            cell.albumArt.image = UIImage(data: data!)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let DeleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: { ( action: UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let realm = try! Realm()
            try! realm.write(){
                realm.delete(self.tracks[indexPath.row])
            }
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            tableView.endUpdates()
        })
        let playAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Play", handler: { ( action: UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let sTrack = SpotifyTrack(track: self.tracks[indexPath.row])
            let url = NSURL(string: sTrack.previewUrl)
            let item = AVPlayerItem(URL: url!)
            tableItems.insert(item, atIndex: 0)
            tableData.insert(sTrack, atIndex: 0)
            tableView.setEditing(false, animated: true)
        })
        
        DeleteAction.backgroundColor = UIColor.redColor()
        playAction.backgroundColor = UIColor.lightGrayColor()
        
        return [DeleteAction, playAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
}

