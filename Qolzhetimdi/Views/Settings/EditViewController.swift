//
//  EditViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Firebase


class EditViewController: UIViewController, EditCell {
    

    @IBOutlet weak var tableView: UITableView!
    var currentUser: FirebaseAuth.User? = Auth.auth().currentUser
    var name: String? = Auth.auth().currentUser?.displayName
    var phone: String? = Auth.auth().currentUser?.phoneNumber
    var imageURL: URL? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        User.currentUser { (user) in
            self.currentUser = user
            self.phone = user?.phoneNumber
            self.name = user?.displayName
        }
    }
    

    @IBAction func savePressed(_ sender: Any) {
        User.updateProfile(name, phone, imageURL)
        self.navigationController?.popViewController(animated: true)
    }

    func nameFieldChanged(_ text: String) {
        name = text
    }
    
    func phoneFieldChanged(_ text: String) {
        phone = text
    }
    
    func cameraPressed() {
        
    }
    
}


extension EditViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! EditProfileTableViewCell
            
            cell.textField.text = currentUser?.displayName
            cell.delegate = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell", for: indexPath) as! FieldTableViewCell
            
            cell.textField.text = currentUser?.phoneNumber
            cell.delegate = self
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            
            return cell
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        
        return 44
    }
}
