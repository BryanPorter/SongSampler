//
//  PlaylistVC.swift
//  Song Sampler
//
//  Created by Bryan Porter on 3/9/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import AVFoundation

var tableData = [SpotifyTrack]()
var tableItems = [AVPlayerItem]()
var pastData = [SpotifyTrack]()

class PlaylistVC : UITableViewController {
    
    @IBAction func clear(sender: AnyObject) {
        tableData.removeAll()
        tableItems.removeAll()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "customCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pastData.removeAll()
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let DeleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove", handler: { ( action: UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            tableView.beginUpdates()
            var indexArray = [NSIndexPath]()
            if(indexPath.row >= pastData.endIndex) {
                indexArray.append(indexPath)
                tableItems.removeAtIndex(indexPath.row - pastData.count)
                tableData.removeAtIndex(indexPath.row - pastData.count)
            }
            for _ in pastData {
                indexArray.append(NSIndexPath(forRow: 0, inSection: 0))
            }
            tableView.deleteRowsAtIndexPaths(indexArray, withRowAnimation: UITableViewRowAnimation.Top)
            pastData.removeAll()
            tableView.endUpdates()
        })
        
        let saveAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Save", handler: { ( action: UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let realm = try! Realm()
            
            let track = RealmTrack()
            if (indexPath.row >= pastData.count){
                track.title = tableData[indexPath.row - pastData.count].title
                track.artist = tableData[indexPath.row - pastData.count].artist
                track.previewUrl = tableData[indexPath.row - pastData.count].previewUrl
                track.albumArt = tableData[indexPath.row - pastData.count].imageUrl
                track.bigAlbumArt = tableData[indexPath.row - pastData.count].bigImageUrl
                
            } else {
                track.title = pastData[indexPath.row].title
                track.artist = pastData[indexPath.row].artist
                track.previewUrl = pastData[indexPath.row].previewUrl
                track.albumArt = pastData[indexPath.row].imageUrl
                track.bigAlbumArt = pastData[indexPath.row].bigImageUrl
                
            }
            try! realm.write() {
                realm.add(track)
            }
            tableView.setEditing(false, animated: true)
        })
        
        DeleteAction.backgroundColor = UIColor.redColor()
        saveAction.backgroundColor = UIColor.lightGrayColor()
        
        return [DeleteAction, saveAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row >= tableData.endIndex) {
            return customCell() //prevents index from going out of range
        } else {
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
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
}
