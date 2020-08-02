//
//  ReviewTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet weak var authorLabel: UILabel!
    var review : Review! {
        didSet {
            self.dateLabel.text = review.date.getDayMonthYear()
            self.bodyLabel.text = review.body
            self.authorLabel.text = review.author.name
            for i in 0..<review.rating {
                (starStackView.subviews[i] as! UIImageView).image = UIImage(systemName: "star.fill")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func replyPressed(_ sender: Any) {
        
    }
    
    
}
