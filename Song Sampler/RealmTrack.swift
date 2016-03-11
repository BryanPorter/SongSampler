//
//  RealmTrack.swift
//  Song Sampler
//
//  Created by Bryan Porter on 3/9/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import UIKit
import RealmSwift

class RealmTrack : Object {
    
    dynamic var title = ""
    dynamic var artist = ""
    dynamic var previewUrl = ""
    dynamic var albumArt = ""
    dynamic var bigAlbumArt = ""
    
}