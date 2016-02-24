//
//  customCell.swift
//  Song Sampler
//
//  Created by Bryan Porter on 2/21/16.
//  Copyright © 2016 Bryan Porter. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var albumArt: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
