//
//  RatingTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var countCell: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingBackground: UIView!
    let ratings = ["Excellent", "Very good", "Average", "Poor"]
    var shop: Shop! {
        didSet {
            ratingLabel.text = "\(shop.getRating)"
            countCell.text = "\(shop.rating.count)"
            for i in 0..<4 {
                (stackView.subviews[i].viewWithTag(3) as! UILabel).text = ratings[i]
                (stackView.subviews[i].viewWithTag(2) as! UILabel).text = "\(shop.rating.getAll[4 - i].0)"
                (stackView.subviews[i].viewWithTag(1) as! UIProgressView).progress = shop.rating.getAll[4 - i].1
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ratingBackground.layer.cornerRadius = 8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
