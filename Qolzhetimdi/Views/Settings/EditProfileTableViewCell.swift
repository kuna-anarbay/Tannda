//
//  EditProfileTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

protocol EditCell {
    func nameFieldChanged(_ text: String)
    func phoneFieldChanged(_ text: String)
    func cameraPressed()
}

class EditProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    var delegate: EditCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        mainImage.layer.cornerRadius = 30
        cameraButton.layer.cornerRadius = 30
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }
    

    @IBAction func cameraPressed(_ sender: Any) {
        delegate.cameraPressed()
    }
    
    @objc func textChanged(_ textField: UITextField){
        if let text = textField.text{
            delegate.nameFieldChanged(text)
        }
    }
}
