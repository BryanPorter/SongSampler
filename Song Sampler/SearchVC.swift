//
//  SearchVC.swift
//  Song Sampler
//
//  Created by Bryan Porter on 3/9/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import AVFoundation
import Foundation
import RealmSwift
import UIKit

class searchVC : UITableViewController, UISearchBarDelegate {
    
    var searchData = [SpotifyTrack]()
    @IBOutlet weak var searchBar: UISearchBar!

    @IBAction func playAll(sender: AnyObject) {
        if(searchData.endIndex == 0 && !searchData.isEmpty){
            
            let url = NSURL(string: searchData[0].previewUrl)
            let item = AVPlayerItem(URL: url!)
            tableItems.insert(item, atIndex: 0)
            tableData.insert(searchData[0], atIndex: 0)
            
        } else if( !searchData.isEmpty){

            let currentItems = tableData.endIndex
            let incVal = currentItems/(searchData.endIndex) + 2
            var insLoc = 0
        
            for track in searchData {
                let url = NSURL(string: track.previewUrl)
                let item = AVPlayerItem(URL: url!)
                tableItems.insert(item, atIndex: insLoc)
                tableData.insert(track, atIndex: insLoc)
                insLoc += incVal
                if(insLoc > tableData.endIndex){
                    insLoc = tableData.endIndex
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "customCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cCell")
        
        searchBar.showsScopeBar = true
        searchBar.delegate = self //necessary to use searchBar
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if(searchBar.text != ""){
            SpotifyManager.search(searchBar.text!) {
                (tracks) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.searchData = tracks
                    self.tableView.reloadData()
                }
            }
        }
        self.view.endEditing(true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:customCell = tableView.dequeueReusableCellWithIdentifier("cCell", forIndexPath: indexPath) as! customCell
        
        cell.title?.text = searchData[indexPath.row].title
        cell.artist?.text = searchData[indexPath.row].artist
        
        let url = NSURL(string: searchData[indexPath.row].imageUrl)
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
        
        let PlayNextAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Play\nNext", handler: { ( action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let url = NSURL(string: self.searchData[indexPath.row].previewUrl)
            let item = AVPlayerItem(URL: url!)
            tableItems.insert(item, atIndex: 0)
            tableData.insert(self.searchData[indexPath.row], atIndex: 0)
            tableView.setEditing(false, animated: true)
        })
        let saveAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Save", handler: { ( action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                
            let realm = try! Realm()
                
            let track = RealmTrack()
            track.title = self.searchData[indexPath.row].title
            track.artist = self.searchData[indexPath.row].artist
            track.previewUrl = self.searchData[indexPath.row].previewUrl
            track.albumArt = self.searchData[indexPath.row].imageUrl
            track.bigAlbumArt = self.searchData[indexPath.row].bigImageUrl
                
            try! realm.write() {
                realm.add(track)
            }
            tableView.setEditing(false, animated: true)
        })
            
        PlayNextAction.backgroundColor = UIColor.grayColor()
        saveAction.backgroundColor = UIColor.lightGrayColor()
            
        return [PlayNextAction, saveAction]
    }
        
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: searchData[indexPath.row].previewUrl)
        let item = AVPlayerItem(URL: url!)
        tableItems.insert(item, atIndex: 0)
        tableData.insert(searchData[indexPath.row], atIndex: 0)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}