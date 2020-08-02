//
//  HistoryCollectionViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class HistoryCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var shopsView: UIView!
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var items: UILabel!
    @IBOutlet weak var shops: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        welcomeText.isHidden = true
        background.layer.cornerRadius = 13
        proceedButton.layer.cornerRadius = 13
    }
}
