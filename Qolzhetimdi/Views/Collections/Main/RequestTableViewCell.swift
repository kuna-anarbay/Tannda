//
//  RequestTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/6/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var items: UILabel!
    @IBOutlet weak var shops: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var invited: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        acceptButton.layer.cornerRadius = 14
        declineButton.layer.cornerRadius = 14
        background.layer.cornerRadius = 13
        proceedButton.layer.cornerRadius = 13
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func acceptPressed(_ sender: Any) {
        
    }
    
    @IBAction func declinePressed(_ sender: Any) {
        
    }
    
}
