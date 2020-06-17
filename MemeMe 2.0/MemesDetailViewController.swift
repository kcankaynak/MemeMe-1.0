//
//  MemesDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Kemal Kaynak on 17.06.20.
//  Copyright © 2020 Kemal Kaynak. All rights reserved.
//

import UIKit

class MemesDetailViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = meme.memedImage
    }
}
