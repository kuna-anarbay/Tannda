//
//  StatisticsTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var shopsStackView: UIStackView!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var totalPrice: UILabel!
    var shops = [(String, Int)]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        for i in 0..<3 {
            stackView.subviews[i].backgroundColor = UIColor(hexString: lists.colors[i])
            (shopsStackView.subviews as! [UIStackView])[0].subviews[i].viewWithTag(2)?.backgroundColor = UIColor(hexString: lists.colors[i])
        }
        for i in 0..<3 {
            stackView.subviews[i + 3].backgroundColor = UIColor(hexString: lists.colors[i + 3])
            (shopsStackView.subviews as! [UIStackView])[1].subviews[i].viewWithTag(2)?.backgroundColor = UIColor(hexString: lists.colors[i + 3])
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
