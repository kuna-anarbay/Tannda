//
//  CollectionsViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/6/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class CollectionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var collections: [Collection] = [Collection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        fetchData()
    }

    
    func fetchData(){
        Collection.getAll { (collections) in
            self.collections = collections
            self.tableView.reloadData()
        }
    }
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollection" {
            let dest = segue.destination as! CollectionViewController
            dest.collection = sender as! Collection
        }
    }
    

}


extension CollectionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collection = collections[indexPath.row]
        if collection.isAccepted {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath) as! DefaultTableViewCell
            cell.title.text = collection.title
            cell.icon.setImage(UIImage(systemName: collection.icon), for: .normal)
            cell.icon.tintColor = UIColor(hexString: collection.color)
            cell.proceedButton.tintColor = UIColor(hexString: collection.color)
            cell.proceedButton.backgroundColor = UIColor(hexString: collection.color).withAlphaComponent(0.15)
            cell.items.text = "\(collection.count)"
            cell.shops.text = collection.shopName ?? "Not specified"
            cell.price.text = "\(collection.sum)₸"
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestTableViewCell
            cell.title.text = collection.title
            cell.icon.setImage(UIImage(systemName: collection.icon), for: .normal)
            cell.icon.tintColor = UIColor(hexString: collection.color)
            cell.proceedButton.tintColor = UIColor(hexString: collection.color)
            cell.proceedButton.backgroundColor = UIColor(hexString: collection.color).withAlphaComponent(0.15)
            cell.items.text = "\(collection.count)"
            cell.shops.text = collection.shopName ?? "Not specified"
            cell.price.text = "\(collection.sum)₸"
            
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let collection = collections[indexPath.row]
        if collection.isAccepted {
            return 125
        } else {
            return 176
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showCollection", sender: collections[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
