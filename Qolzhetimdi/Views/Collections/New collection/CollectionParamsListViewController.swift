//
//  CollectionParamsListViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Contacts


class CollectionParamsListViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating {
    

    @IBOutlet weak var tableView: UITableView!
    let authStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    var contacts = [CNContact]()
    var selectedContacts = [CNContact]()
    var searchController = UISearchController()
    var searchedContacts = [CNContact]()
    var friends = [User]()
    var searching : Bool {
        get {
            return searchController.searchBar.text != nil && searchController.searchBar.text!.count > 0
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchContacts()
        setupSearchBarController()
    }
    
    
    func setupSearchBarController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search contacts"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.delegate = self
    }
    
    func fetchFriends(){
        if self.contacts.count > 0 {
            let temp = self.contacts.filter { (contact) -> Bool in
                return contact.phoneNumbers.count > 0
            }.map({ (contact) -> String in
                return contact.phoneNumbers[0].value.stringValue
            })
            User.getFriends(temp) { (friends) in
                self.friends = friends
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchContacts(){
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey, CNContactImageDataKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        if authStatus == .authorized {
            do {
                try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stop) in
                    self.contacts.append(contact)
                })
                self.fetchFriends()
                self.tableView.reloadData()
            } catch {
                print("unable to fetch contacts")
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            searchedContacts = contacts.filter({ (contact) -> Bool in
                return contact.givenName.contains(text) || contact.familyName.contains(text) || contact.phoneNumbers.contains(where: { (number) -> Bool in
                    return number.value.stringValue.contains(text)
                })
            })
            tableView.reloadData()
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CollectionParamsListViewController: UITableViewDataSource, UITableViewDelegate, EmptyCell {
    
    
    func buttonPressed() {
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
            self.fetchContacts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if authStatus == .notDetermined {
            return 1
        }
        
        return searching ? searchedContacts.count : contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if authStatus == .notDetermined {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as! EmptyTableViewCell
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
            let contact = searching ? searchedContacts[indexPath.row] : contacts[indexPath.row]
            if friends.count > 0, let friend = friends.first(where: {$0.phone == contact.phoneNumbers[0].value.stringValue}) {
                cell.button.isHidden = true
            }
            if contact.familyName.count > 0 && contact.givenName.count > 0 {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: contact.givenName)
                let attrString = NSMutableAttributedString(string: " " + contact.familyName)
                attrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: NSMakeRange(0, attrString.length))
                attributeString.append(attrString)
                cell.titleLabel.attributedText = attributeString
            } else if contact.familyName.count > 0 {
                cell.textLabel?.text = contact.familyName
            } else if contact.givenName.count > 0 {
                cell.titleLabel.text = contact.givenName
            } else {
                cell.titleLabel.text = contact.phoneNumbers[0].value.stringValue
            }
            if let data = contact.imageData {
                cell.mainImage.image = UIImage(data: data)
            } else {
                cell.mainImage.image = UIImage(systemName: "7.circle.fill")
            }
            
            cell.accessoryType = selectedContacts.contains(contact) ? .checkmark : .none
            
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if authStatus == .authorized {
            let contact = searching ? searchedContacts[indexPath.row] : contacts[indexPath.row]
            if let index = selectedContacts.firstIndex(of: contact) {
                selectedContacts.remove(at: index)
            } else {
                selectedContacts.append(contact)
            }
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if authStatus == .notDetermined {
            return tableView.bounds.height
        }
        
        return 44
    }
}
