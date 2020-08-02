//
//  SearchViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var searchController = UISearchController()
    var items = [Item]()
    var shops = [Shop]()
    var itemsSearch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupSearchBarController()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupSearchBarController() {
        searchController.searchBar.scopeButtonTitles = ["Items", "Shops"]
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search contacts"
        searchController.searchBar.becomeFirstResponder()
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.delegate = self
    }
    
    
    
    func fetchData(){
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            if let text = searchController.searchBar.text {
                Item.getAll(text) { (items) in
                    self.items = items
                    self.tableView.reloadData()
                }
            }
        } else {
            if let text = searchController.searchBar.text {
                Shop.getAll { (shops) in
                    self.shops = shops
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShop" {
            let dest = segue.destination as! ShopViewController
            dest.shop = sender as! Shop
        }
    }
    

}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            return items.count
        }
        return shops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
            let item = items[indexPath.row]
            
            cell.titleLabel.text = item.name
            cell.countLabel.text = "\(item.priceSum/item.priceCount)₸"
            cell.mainImage.setImage(from: URL(string: item.image))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! ShopTableViewCell
            let shop = shops[indexPath.row]
            
            cell.shopLabel.text = shop.name
            cell.mainImage.setImage(from: URL(string: shop.logo))
            cell.timeLabel.text = shop.todayOpen
            
            return cell
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            
        } else {
            performSegue(withIdentifier: "showShop", sender: self.shops[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.fetchData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        itemsSearch = selectedScope==0
        self.items = []
        self.shops = []
        self.tableView.reloadData()
        self.fetchData()
    }
    
}
