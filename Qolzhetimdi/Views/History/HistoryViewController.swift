//
//  HistoryViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Firebase


class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var allHistory = [String: [History]]()
    var collectionHistory = [String: [History]]()
    var collections = [Collection]()
    var collectionIds = [String]()
    var months = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        let nib = UINib(nibName: "SectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
    }
    

    func fetchData(){
        Collection.getAll { (collections) in
            self.collections = collections
            self.collectionIds = collections.map({ (collection) -> String in
                return collection.id
            })
            if self.collectionIds.count > 0 {
                self.fetchHistory()
            }

            self.pageControl.numberOfPages = self.collectionIds.count + 1
            self.collectionView.reloadData()
        }
    }
    
    func fetchHistory(){
        History.getAll(collectionIds) { (history) in
            self.allHistory = [:]
            for item in history {
                if self.allHistory[item.date.getMonthAndYear()] == nil {
                    self.allHistory[item.date.getMonthAndYear()] = [item]
                } else {
                    self.allHistory[item.date.getMonthAndYear()]?.append(item)
                }
            }
            self.collectionHistory = self.allHistory
            self.months = self.collectionHistory.keys.map({ (key) -> String in
                return key
            })
            self.tableView.reloadData()
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCheck" {
            let dest = segue.destination as! CheckViewController
            dest.collection = self.collections.first(where: { (collection) -> Bool in
                return collection.id == (sender as! History).collectionId
            })!
            dest.items = (sender as! History).items
            dest.confirmState = false
            dest.history = (sender as! History)
        } else if segue.identifier == "showStatistics" {
            let dest = segue.destination as! StatisticsViewController
            allHistory.forEach { (value) in
                dest.history.append(contentsOf: value.value)
            }
        }
    }
    

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let last = collectionView.visibleCells.last {
            let indexPath = collectionView.indexPath(for: last)
            if let row = indexPath?.row {
                self.pageControl.currentPage = row
                print(row)
                self.collectionHistory = allHistory.filter({ (arg0) -> Bool in
                    let contains = arg0.value.contains(where: { (item) -> Bool in
                        if row == 0 {
                            return true
                        }
                        return item.collectionId == collectionIds[row - 1]
                    })
                    print(contains)
                    return contains
                })
                self.months = collectionHistory.keys.map({ (key) -> String in
                    return key
                })
                if row > 0 {
                    print(months, collectionIds[row - 1])
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return months.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionHistory[months[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        let item = collectionHistory[months[indexPath.section]]![indexPath.row]
        cell.authorLabel.text = item.author.name
        cell.shopsLabel.text = item.shopName
        cell.itemsLabel.text = "\(item.items.count) items"
        var price = 0
        item.items.forEach { (item) in
            if item.price >= 0 {
                price += (item.price*item.count)
            }
        }
        cell.priceLabel.text = "\(price)₸"
        cell.dateLabel.text = item.date.getDayAndMonth()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCheck", sender: collectionHistory[months[indexPath.section]]![indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! SectionHeader
        sectionHeader.titleLabel.text = months[section]
        sectionHeader.detailLabel.text = ""
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}



extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCollectionViewCell
        if indexPath.row == 0 {
            cell.title.isHidden = true
            cell.welcomeText.isHidden = false
            cell.welcomeText.text = "Welcome back,\n" + ((Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.phoneNumber) ?? "Adlet")
            cell.icon.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
            cell.icon.tintColor = UIColor(named: "Main")
            cell.proceedButton.tintColor = UIColor.label
            cell.proceedButton.backgroundColor = UIColor.label.withAlphaComponent(0.05)
            cell.itemsView.isHidden = true
            cell.shopsView.isHidden = true
            cell.price.text = "\(0)₸"
        } else {
            let collection = collections[indexPath.row - 1]
            cell.title.text = collection.title
            cell.icon.setImage(UIImage(systemName: collection.icon), for: .normal)
            cell.icon.tintColor = UIColor(hexString: collection.color)
            cell.proceedButton.tintColor = UIColor(hexString: collection.color)
            cell.proceedButton.backgroundColor = UIColor(hexString: collection.color).withAlphaComponent(0.15)
            cell.items.text = "\(collection.count)"
            cell.shops.text = collection.shopName ?? "Not specified"
            cell.price.text = "\(collection.sum)₸"
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}
