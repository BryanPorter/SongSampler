//
//  ViewController.swift
//  Song Sampler
//
//  Created by Bryan Porter on 2/21/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

/*
import AVFoundation
import RealmSwift
import UIKit

    var player : AVQueuePlayer!
    var items = [AVPlayerItem]()

class ViewController: UIViewController {
    
    var tableData = [SpotifyTrack]()
   

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    func playSong(){
        if(player.currentItem != nil){
            var toolbarItems = self.toolbar.items
            let newItem = UIBarButtonItem.init(barButtonSystemItem: .Pause, target: self, action: "pauseSong")
            toolbarItems![2] = newItem
            self.toolbar.setItems(toolbarItems, animated:false)
        } else {
            playAll()
        }
        player.play()
    }
    func pauseSong(){
        var toolbarItems = self.toolbar.items
        let newItem = UIBarButtonItem.init(barButtonSystemItem: .Play, target: self, action: "playSong")
        toolbarItems![2] = newItem
        self.toolbar.setItems(toolbarItems, animated:false)
        
        player.pause()
    }
    
    func clearList(){
        player.removeAllItems()
    }
    func nextSong(){
        player.advanceToNextItem()
        playSong()
    }
    func playAll(){
        //Add songs in a slightly shuffled manner rather than only to end
        print(player.items().endIndex)
        let currentItems = player.items()
        let incVal = currentItems.endIndex/30
        var insLoc = 1
        
        for track in tableData {
            let url = NSURL(string: track.previewUrl)
            let item = AVPlayerItem(URL: url!)
            if(currentItems.endIndex > insLoc && player.canInsertItem(item, afterItem: currentItems[insLoc])){
                player.insertItem(item, afterItem:currentItems[insLoc])
                insLoc = insLoc + incVal
            } else if(player.canInsertItem(item, afterItem: nil)){
                player.insertItem(item, afterItem: nil)
            }
        }
        if(player.currentItem != nil){
            playSong()
        }
    }

    func createToolbar() {
        let resetButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "clearList")
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let nextButton = UIBarButtonItem.init(barButtonSystemItem: .FastForward, target: self, action: "nextSong")
        let playButton = UIBarButtonItem.init(barButtonSystemItem: .Play, target: self, action: "playSong")
        let playAll = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "playAll")
        toolbar.setItems([resetButton, flexSpace, playButton, nextButton, flexSpace, playAll], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "customCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cCell")

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch { //Report an error
        }
        
        player = AVQueuePlayer(items: items)
        player.usesExternalPlaybackWhileExternalScreenIsActive = true
        
        createToolbar()
    }

}


extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let rate:Float? = Float(searchBar.text!)
        if (rate != nil) {
            player.rate = (rate! * 0.1) % 2
            if(player.rate == 0){
                player.rate = 1.0
            }
        } else {
            SpotifyManager.search(searchBar.text!) {
                (tracks) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableData = tracks
                    self.tableView.reloadData()
                }
            }
        }
        self.view.endEditing(true)
    }
}


extension ViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:customCell = tableView.dequeueReusableCellWithIdentifier("cCell", forIndexPath: indexPath) as! customCell
        
        cell.title?.text = tableData[indexPath.row].title
        cell.artist?.text = tableData[indexPath.row].artist
        
        let url = NSURL(string: tableData[indexPath.row].imageUrl)
        let data = NSData(contentsOfURL: url!)
        if (data != nil){
            cell.albumArt.image = UIImage(data: data!)
        }
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let PlayNextAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Play\nNext", handler: { ( action: UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let url = NSURL(string: self.tableData[indexPath.row].previewUrl)
            let item = AVPlayerItem(URL: url!)
            let currentItems = player.items()
            
            print(currentItems)
            if(currentItems != []){
                if(player.canInsertItem(item, afterItem: currentItems[0])){
                    player.insertItem(item, afterItem: currentItems[0])
                }
            } else {
                player.insertItem(item, afterItem: nil)
            }
            self.playSong()
            
        })
        let saveAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Save", handler: { ( action: UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let realm = try! Realm()
            
            let track = RealmTrack()
            track.title = self.tableData[indexPath.row].title
            track.artist = self.tableData[indexPath.row].artist
            track.previewUrl = self.tableData[indexPath.row].previewUrl
            track.albumArt = self.tableData[indexPath.row].imageUrl
            
            try! realm.write() {
                realm.add(track)
                print("wrote \(track.title) to realm")
            }
        })
        
        PlayNextAction.backgroundColor = UIColor.grayColor()
        saveAction.backgroundColor = UIColor.lightGrayColor()
        
        return [PlayNextAction, saveAction]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}


extension ViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let url = NSURL(string: tableData[indexPath.row].previewUrl)
        let item = AVPlayerItem(URL: url!)

        let currentItems = player.items()

        if(currentItems != []){
            if(player.canInsertItem(item, afterItem: currentItems[0])){
                player.insertItem(item, afterItem: currentItems[0])
            }
        } else {
            player.insertItem(item, afterItem: nil)
        }
        nextSong()
    }
    
}
*/