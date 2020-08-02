//
//  StatisticsViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var shops = [(String, Int)]()
    var items = [CollectionItem]()
    var history: [History] = [History]()
    var totalPrice: Int = 0
    var sortedByPrice = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let nib = UINib(nibName: "SectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
        
        print(history)
        for check in history {
            var price = 0
            for item in check.items {
                if let index = items.firstIndex(where: {$0.name == item.name}) {
                    if item.price > 0 {
                        price += item.price*item.count
                        items[index].price += item.price*item.count
                    }
                    items[index].count += item.count
                } else {
                    if item.price < 0 {
                        item.price = 0
                    }
                    items.append(item)
                }
            }
            totalPrice += price
            if let name = check.shopName, let index = shops.firstIndex(where: {$0.0 == name}) {
                shops[index].1 += price
            } else if let name = check.shopName {
                shops.append((name, price))
            }
        }
        items = items.sorted { (i1, i2) -> Bool in
            if sortedByPrice {
                return i1.price > i2.price
            }
            return i1.count > i2.count
        }
    }
    

    @IBAction func sortByPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Amount", style: .default, handler: { (_) in
            self.sortedByPrice = true
            self.items = self.items.sorted { (i1, i2) -> Bool in
                return i1.price > i2.price
            }
            self.tableView.reloadSections([1], with: .automatic)
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Count", style: .default, handler: { (_) in
            self.sortedByPrice = false
            self.items = self.items.sorted { (i1, i2) -> Bool in
                return i1.count > i2.count
            }
            self.tableView.reloadSections([1], with: .automatic)
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}


extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statisticsCell", for: indexPath) as! StatisticsTableViewCell
            cell.shops = self.shops.sorted(by: { (s1, s2) -> Bool in
                return s1.1 > s2.1
            })
            
            return cell
        }
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = item.name
        if item.price > 0 {
            cell.detailTextLabel?.text = "\(item.count) items = \(item.price)₸"
        } else {
            cell.detailTextLabel?.text = "\(item.count) items"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 230
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let sectionHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! SectionHeader
            sectionHeader.titleLabel.text = "Top items"
            sectionHeader.detailLabel.text = ""
            
            return sectionHeader
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 44
    }
    
    
}
