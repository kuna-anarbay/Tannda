//
//  ItemSmallTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

protocol ItemTableViewDelegate {
    func optionsPressed(_ indexPath: IndexPath, _ state: ItemSmallTableViewCell.itemState)
    func checkPressed(_ indexPath: IndexPath, _ state: ItemSmallTableViewCell.itemState)
}

class ItemSmallTableViewCell: UITableViewCell {

    public enum itemState {
        case normal
        case choose
    }
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var indexPath: IndexPath!
    var delegate: ItemTableViewDelegate!
    var currentState: itemState = .normal
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkPressed(_ sender: Any) {
        delegate.checkPressed(indexPath, currentState)
    }
    
    @IBAction func optionsPressed(_ sender: Any) {
        print("pressed")
        delegate.optionsPressed(indexPath, currentState)
    }
    
}
