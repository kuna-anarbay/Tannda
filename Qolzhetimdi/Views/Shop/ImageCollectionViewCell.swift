//
//  ImageCollectionViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/12/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate {
    func remove(_ indexPath: IndexPath)
    func select(_ indexPath: IndexPath)
}
class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    var indexPath = IndexPath()
    var delegate: ImageCollectionViewCellDelegate!
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate.remove(indexPath)
    }
    
}
