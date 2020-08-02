//
//  ItemLargeTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class ItemLargeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var indexPath: IndexPath!
    var delegate: ItemTableViewDelegate!
    var currentState: ItemSmallTableViewCell.itemState = .normal
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        locationView.layer.cornerRadius = 12
        locationView.isHidden = true
        countView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func optionsPressed(_ sender: Any) {
        delegate.optionsPressed(indexPath, currentState)
    }
    
    @IBAction func checkPressed(_ sender: Any) {
        delegate.checkPressed(indexPath, currentState)
    }
    
}
