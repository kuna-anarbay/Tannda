//
//  CheckViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Firebase


class CheckViewController: UIViewController {

    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var priceConfirmLabel: UIButton!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    var items = [CollectionItem]()
    var collection: Collection = Collection()
    var confirmState = false
    var history: History = History()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tableView.isScrollEnabled = CGFloat(items.count*44 + 160) >= self.view.frame.height - 88
        viewHeightConstraint.constant = min(CGFloat(items.count*44 + 160), self.view.frame.height - 88)
        
        
        confirmView.layer.cornerRadius = 8
        confirmView.isHidden = !confirmState
        PriceLabel.isHidden = confirmState
        chargeLabel.isHidden = confirmState
        
        background.layer.cornerRadius = 8
        topView.layer.cornerRadius = 8
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.layer.cornerRadius = 8
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let nib = UINib(nibName: "CheckHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customCheckHeader")
        
        var price = 0
        items.forEach { (item) in
            if item.price >= 0 {
                price += (item.price*item.count)
            }
        }
        PriceLabel.text = "\(price)₸"
        dateLabel.text = history.date.getDayAndMonth()
        titleLabel.text = collection.title
        authorLabel.text = Auth.auth().currentUser?.displayName
        
        priceConfirmLabel.setTitle("\(price)₸", for: .normal)
        imageView.image = UIImage(systemName: collection.icon)
        imageView.tintColor = UIColor(hexString: collection.color)
        imageBackground.backgroundColor = UIColor(hexString: collection.color).withAlphaComponent(0.15)
        imageBackground.layer.cornerRadius = 16
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        let alert = self.loadingAlert()
        self.present(alert, animated: true, completion: nil)
        
        History.create(collection, items) { (arg0) in
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
   
}



extension CheckViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        if item.price >= 0 {
            cell.detailTextLabel?.text = "\(item.count) x \(item.price) = \(item.count*item.price)₸"
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let checkHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customCheckHeader") as! CheckHeader
        checkHeader.shopName.text = collection.shopName ?? "Mail"
        
        
        return checkHeader
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
}
