//
//  PropertyCollectionViewCell.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

protocol PropertyCollectionViewCellDelegate {
    func didselect(_ indexPath: IndexPath, _ state: PropertyCollectionViewCell.propertyState)
}

class PropertyCollectionViewCell: UICollectionViewCell {
    
    public enum propertyState {
        case friends
        case shops
        case history
    }
    @IBOutlet weak var tableView: UITableView!
    var members = [Member]()
    var shops = ["Shop", "Shop"]
    var history = [History]()
    var delegate: PropertyCollectionViewCellDelegate!
    var currentState: propertyState = .friends
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        let nib = UINib(nibName: "SectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
    }
    
    
}


extension PropertyCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentState {
        case .friends:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case .friends:
            if section == 0 {
                return members.count + 1
            }
            return 1
        case .shops:
            return shops.count
        case .history:
            return history.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch currentState {
        case .friends:
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
                
                if indexPath.row == 0 {
                    cell.titleLabel.text = "Add member"
                    cell.button.isHidden = true
                    cell.mainImage.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 17), scale: .medium))
                    cell.mainImage.tintColor = UIColor(named: "Main")
                    cell.mainImage.backgroundColor = UIColor(named: "Main")?.withAlphaComponent(0.15)
                } else {
                    let member = members[indexPath.row - 1]
                    
                    cell.titleLabel.text = member.name
                    
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
                
                return cell
            }
        case .shops:
            let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopTableViewCell
            
            return cell
        case .history:
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
            let item = history[indexPath.row]
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
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch currentState {
        case .friends:
            delegate.didselect(indexPath, currentState)
        case .shops:
            delegate.didselect(indexPath, currentState)
        case .history:
            delegate.didselect(indexPath, currentState)
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch currentState {
        case .friends:
            
            let sectionHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! SectionHeader
            if section == 1 {
                sectionHeader.titleLabel.text = ""
//                sectionHeader.bottomSeparator.backgroundColor = .separator
            } else {
                sectionHeader.titleLabel.text = "Friends"
            }
            
            sectionHeader.detailLabel.text = ""
            
            return sectionHeader
        case .shops:
            let sectionHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! SectionHeader
            sectionHeader.titleLabel.text = "Shops"
            sectionHeader.detailLabel.text = ""
            
            return sectionHeader
        case .history:
            let sectionHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! SectionHeader
            sectionHeader.titleLabel.text = "History"
            sectionHeader.detailLabel.text = ""
            
            return sectionHeader
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 44
        }
        if currentState == .friends {
            return 38
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentState {
        case .friends:
            return 44
        case .shops:
            return 72
        case .history:
            return 72
        }
    }
}
