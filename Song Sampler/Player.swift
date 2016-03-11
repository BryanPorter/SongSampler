//
//  Player.swift
//  Song Sampler
//
//  Created by Bryan Porter on 3/9/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var player : AVPlayer!

class playerVC : UIViewController {
    
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var Slider: UISlider!
    
    @IBAction func SpeedAdjust(sender: AnyObject) {
        player.volume = Slider.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistLabel.text = ""
        titleLabel.text = ""
        
        let flexSpace = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        let nextButton = UIBarButtonItem.init(barButtonSystemItem: .FastForward, target: self, action: "nextSong")
        let playButton = UIBarButtonItem.init(barButtonSystemItem: .Play, target: self, action: "playSong")
        toolbar.setItems([flexSpace, playButton, nextButton, flexSpace], animated: true)
    }
    
    func pauseSong(){
        player.pause()
        let playButton = UIBarButtonItem.init(barButtonSystemItem: .Play, target: self, action: "playSong")
        toolbar.items![1] = playButton
    }
    
    func playSong(){
        if(player.currentItem != nil){ //has an item that it is currently playing
            player.play()

            let pauseButton = UIBarButtonItem.init(barButtonSystemItem: .Pause, target: self, action: "pauseSong")
            toolbar.items![1] = pauseButton
            
        } else if(!tableData.isEmpty){
            let track = tableData.removeFirst()

            player = AVPlayer(playerItem: tableItems.removeFirst())
            player.play()
            player.volume = Slider.value
            
            artistLabel.text = track.artist
            titleLabel.text = track.title
            
            let imageUrl = NSURL(string: track.bigImageUrl)
            let data = NSData(contentsOfURL: imageUrl!)
            if (data != nil){
                image.image = UIImage(data: data!)
            }
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:",
                name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)

            let pauseButton = UIBarButtonItem.init(barButtonSystemItem: .Pause, target: self, action: "pauseSong")
            toolbar.items![1] = pauseButton
        }
    }
    
    func nextSong(){
        if(!tableData.isEmpty){
            pastData.append(tableData.removeFirst())
            
            player = AVPlayer(playerItem: tableItems.removeFirst())
            player.play()
            player.volume = Slider.value
            
            artistLabel.text = pastData.last!.artist
            titleLabel.text = pastData.last!.title
            
            let imageUrl = NSURL(string: pastData.last!.bigImageUrl)
            let data = NSData(contentsOfURL: imageUrl!)
            if (data != nil){
                image.image = UIImage(data: data!)
            }
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:",
                name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
            
        } else {
            pauseSong()
        }
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.nextSong()
    }
}

