//
//  EmptyTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/6/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

protocol EmptyCell {
    func buttonPressed()
}


class EmptyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    var delegate: EmptyCell! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        mainButton.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonPressed(_ sender: Any) {
        delegate.buttonPressed()
    }
}
