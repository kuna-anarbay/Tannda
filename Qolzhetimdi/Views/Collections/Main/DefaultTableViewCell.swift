//
//  DefaultTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/6/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var items: UILabel!
    @IBOutlet weak var shops: UILabel!
    @IBOutlet weak var price: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        background.layer.cornerRadius = 13
        proceedButton.layer.cornerRadius = 13
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
