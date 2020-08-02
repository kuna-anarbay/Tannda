//
//  CollectionPropertiesViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class CollectionPropertiesViewController: UIViewController {

    var collection: Collection = Collection()
    var history: [History] = [History]()
    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.iconBackground.layer.cornerRadius = 30
        fetchData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setStyle(collection)
        self.tabBarController?.tabBar.isHidden = true
    }

    
    func setStyle(_ collection: Collection) {
        self.title = collection.title
        self.imageView.image = UIImage(systemName: collection.icon)
        self.imageView.tintColor = UIColor(hexString: collection.color)
        self.titleLabel.text = collection.title
        self.detailsLabel.text = "\(collection.count) items"
        self.iconBackground.backgroundColor = UIColor(hexString: collection.color).withAlphaComponent(0.15)
    }
    
    func fetchData(){
        collection.getThis { (collection) in
            self.collection = collection
            self.setStyle(collection)
            self.collectionView.reloadData()
        }
        History.getAll(collection.id) { (history) in
            self.history = history
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func segmentChanges(_ sender: UISegmentedControl) {
        collectionView.scrollToItem(at: IndexPath(row: sender.selectedSegmentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCheck" {
            let dest = segue.destination as! CheckViewController
            dest.collection = self.collection
            dest.items = (sender as! History).items
            dest.confirmState = false
            dest.history = (sender as! History)
        }
    }
    

}




extension CollectionPropertiesViewController: PropertyCollectionViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "propertyCell", for: indexPath) as! PropertyCollectionViewCell
        cell.delegate = self
        
        switch indexPath.row {
        case 0:
            cell.currentState = .friends
            cell.members = collection.members
        case 1:
            cell.currentState = .shops
        default:
            cell.history = history
            cell.currentState = .history
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    
    func didselect(_ indexPath: IndexPath, _ state: PropertyCollectionViewCell.propertyState) {
        switch state {
        case .friends:
            if indexPath.row == 0 {
                performSegue(withIdentifier: "showContacts", sender: nil)
            }
        case .history:
            performSegue(withIdentifier: "showCheck", sender: history[indexPath.row])
        case .shops:
            print("shops")
        }
    }
}

