//
//  MemeTableViewCell.swift
//  MemeMe 2.0
//
//  Created by Kemal Kaynak on 17.06.20.
//  Copyright © 2020 Kemal Kaynak. All rights reserved.
//

import UIKit

class MemesTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    func setup(_ data: Meme) {
        imgView.image = data.memedImage
        memeLabel.text = data.topText + " " + data.bottomText
    }
}
