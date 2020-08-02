//
//  StyleCollectionViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class StyleCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var checkedBackground: UIView!
    @IBOutlet weak var checkedImage: UIImageView!
    
    override func awakeFromNib() {
        

        background.layer.cornerRadius = background.bounds.width/2
    }
}
