//
//  FieldTableViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    var delegate: EditCell!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }


    @objc func textChanged(_ field: UITextField){
        if let text = textField.text{
            delegate.phoneFieldChanged(text)
        }
    }
}
