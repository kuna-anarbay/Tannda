//
//  ProfileViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var currentUser: FirebaseAuth.User? = Auth.auth().currentUser
    
    let items = [
        ("Friends", "rectangle.stack.person.crop.fill", UIColor.systemOrange),
        ("Notifications", "app.badge.fill", UIColor.systemBlue),
        ("Apperance", "sun.max.fill", UIColor.systemIndigo),
        ("Language", "textformat", UIColor.systemGreen),
        ("Blocked contacts", "person.crop.circle.fill.badge.xmark", UIColor.systemRed)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        User.currentUser { (user) in
            self.currentUser = user
        }
    }
    

    
    func showAlert(state: String) {
        if state == "lang" {
            let currentLang = NSLocale.current.languageCode
            
            let alert = UIAlertController(title: "App language", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Қазақша", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction(title: "English", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction(title: "Русский", style: .default, handler: { (action) in
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Appearance", message: nil, preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "System", style: .default, handler: { (action) in
                self.view.window?.overrideUserInterfaceStyle = .unspecified
            }))
            alert.addAction(UIAlertAction(title: "Light", style: .default, handler: { (action) in
                self.view.window?.overrideUserInterfaceStyle = .light
            }))
            alert.addAction(UIAlertAction(title: "Dark", style: .default, handler: { (action) in
                self.view.window?.overrideUserInterfaceStyle = .dark
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            
            cell.nameLabel.text = currentUser?.displayName ?? "Name not set"
            cell.phoneLabel.text = currentUser?.phoneNumber
            
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row].0
            cell.imageView?.image = UIImage(systemName: items[indexPath.row].1)
            cell.imageView?.tintColor = items[indexPath.row].2
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Ask a question"
                cell.imageView?.image = UIImage(systemName: "questionmark.circle.fill")
                cell.imageView?.tintColor = UIColor.systemPurple
            } else {
                cell.textLabel?.text = "FAQ"
                cell.imageView?.image = UIImage(systemName: "info.circle.fill")
                cell.imageView?.tintColor = UIColor.systemPink
            }
            return cell
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            performSegue(withIdentifier: "showEdit", sender: nil)
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "showContacts", sender: nil)
            case 1:
                performSegue(withIdentifier: "showNotifications", sender: nil)
            case 2:
                showAlert(state: "appearance")
            case 3:
                showAlert(state: "lang")
            default:
                performSegue(withIdentifier: "showContacts", sender: nil)
            }
        } else {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "showQuestion", sender: nil)
            } else {
                performSegue(withIdentifier: "showFaqs", sender: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        
        return 44
    }
}
