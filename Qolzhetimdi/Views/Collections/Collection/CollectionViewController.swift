//
//  CollectionViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var avatarBackground: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var collectionavatar: UIImageView!
    @IBOutlet weak var swipeImage: UIImageView!
    @IBOutlet weak var searchViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var filteredCount: UILabel!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var textBackgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBackgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textBackground: UIView!
    var items = [CollectionItem]()
    var shopItems = [Item]()
    var allItems = [(String, Int, Int)]()
    var filteredItems = [(String, Int, Int)]()
    var collection: Collection = Collection()
    var selectedItem: CollectionItem? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        textView.text = "Type an item"
        textView.textColor = .lightGray
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 30)
        var frame = self.textView.frame
        frame.size.height = self.textView.contentSize.height
        textBackgroundHeightConstraint.constant = min(frame.height + 24, 100)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        
        
        addButton.layer.cornerRadius = 15
        textView.layer.cornerRadius = 18

        searchView.layer.cornerRadius = 10
        searchView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        searchViewHeightConstraint.constant = 0
        searchViewBottomConstraint.constant = -36
        searchView.layer.shadowColor = UIColor.clear.cgColor
        searchView.layer.masksToBounds = false
        searchView.layer.shadowRadius = 10
        searchView.layer.shadowOpacity = 0.5
        
        
        checkOutButton.layer.cornerRadius = 16.5
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        itemsTableView.addGestureRecognizer(tap)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        upSwipe.direction = .up
        downSwipe.direction = .down
        searchView.addGestureRecognizer(upSwipe)
        searchView.addGestureRecognizer(downSwipe)
        
        
        fetchData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationTitle(collection)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    
    
    
    func setNavigationTitle(_ collection: Collection, _ caption: String? = nil) {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 44, height: 44))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 4, width: titleView.bounds.width - 44, height: caption == nil ? 40 : 22))
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.text = collection.title
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleView.addSubview(titleLabel)
        if caption != nil {
            let captionLabel = UILabel(frame: CGRect(x: 0, y: 26, width: titleView.bounds.width, height: 14))
            captionLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            captionLabel.text = caption
            captionLabel.textAlignment = .center
            captionLabel.textColor = UIColor(named: "Light gray")
            titleView.addSubview(captionLabel)
        }
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        navigationItem.titleView = titleView
        collectionavatar.image = UIImage(systemName: collection.icon)
        collectionavatar.tintColor = UIColor(hexString: collection.color)
        avatarBackground.backgroundColor = UIColor(hexString: collection.color).withAlphaComponent(0.15)
        avatarBackground.layer.cornerRadius = 18
    }
    
    func fetchData(){
        collection.getThis { (collection) in
            self.collection = collection
            self.setNavigationTitle(collection)
        }
        CollectionItem.getAll(collection.id) { (items) in
            self.items = items
            self.itemsTableView.reloadData()
        }
        if let id = collection.shopId {
            Item.getShopItem(id) { (items) in
                self.shopItems = items
            }
        }
    }
    
    @objc func handleTap(){
        self.performSegue(withIdentifier: "showProperties", sender: nil)
    }
    
    @IBAction func showProperties(_ sender: Any) {
        self.performSegue(withIdentifier: "showProperties", sender: nil)
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showCheck", sender: nil)
    }
    
    
    @IBAction func checkOutPressed(_ sender: Any) {
        
    }
    
    
    
    @objc func handleSwipes(_ gesture: UISwipeGestureRecognizer) {
        let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        if gesture.direction == .up && searchView.frame.minY > height+44 {
            searchViewHeightConstraint.constant += (searchView.frame.minY - 44 - height)
        } else if gesture.direction == .down && searchView.frame.height >= CGFloat(min(filteredItems.count*50+36, 192)) {
            searchViewHeightConstraint.constant = CGFloat(min(filteredItems.count*50+36, 192))
        }
        
        UIViewPropertyAnimator(duration: TimeInterval(0.5), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        var frame = self.textView.frame
        frame.size.height = self.textView.contentSize.height
        textBackgroundHeightConstraint.constant = min(frame.height + 24, 100)
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let subStrings = text.split(separator: "#", maxSplits: 100, omittingEmptySubsequences: true)
        if let last = subStrings.last, let first = subStrings.first {
            if let count = Int(String(last)) {
                filteredItems = allItems.filter({$0.0.lowercased().contains(first.lowercased())}).map({ (item) -> (String, Int, Int) in
                    return (item.0, count, item.2)
                })
            } else {
                filteredItems = allItems.filter({$0.0.lowercased().contains(first.lowercased())})
            }
        } else {
            filteredItems = allItems.filter({$0.0.lowercased().contains(textView.text.lowercased())})
        }
        filteredCount.text = "\(filteredItems.count) items"
        if filteredItems.count > 0 {
            searchViewHeightConstraint.constant = CGFloat(min(filteredItems.count*50+36, 192))
            searchViewBottomConstraint.constant = 0
            searchView.layer.shadowColor = UIColor.darkGray.cgColor
            UIViewPropertyAnimator(duration: TimeInterval(0.5), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
                self.view.layoutIfNeeded()
            }.startAnimation()
        } else {
            searchViewHeightConstraint.constant = 0
            searchViewBottomConstraint.constant = -36
            searchView.layer.shadowColor = UIColor.clear.cgColor
            UIViewPropertyAnimator(duration: TimeInterval(0.5), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
        searchTableView.reloadData()
    }
    
    
    @IBAction func addPressed(_ sender: Any) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            let subStrings = text.split(separator: "#", maxSplits: 100, omittingEmptySubsequences: true)
            
            var newItem = CollectionItem()
            if let last = subStrings.last, let first = subStrings.first {
                if let count = Int(String(last)) {
                    newItem = CollectionItem(String(first), -1, count)
                } else {
                    newItem = CollectionItem(String(first))
                }
            } else {
                newItem = CollectionItem(text)
            }
            newItem.create(collection.id) { (arg0) in
                let (status, message) = arg0
                if status == .error {
                    
                } else {
                    
                }
            }
            self.textView.text = "Type an item"
            self.textView.textColor = .lightGray
            self.searchViewHeightConstraint.constant = 0
            self.searchViewBottomConstraint.constant = -36
            self.searchView.layer.shadowColor = UIColor.clear.cgColor
            UIViewPropertyAnimator(duration: TimeInterval(0.5), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
                self.view.layoutIfNeeded()
            }.startAnimation()
            self.filteredItems = []
            self.searchTableView.reloadData()
            self.itemsTableView.reloadData()
            self.view.endEditing(true)
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            textBackgroundBottomConstraint.constant = +(keyboardHeight - 44)
            UIViewPropertyAnimator(duration: TimeInterval(0.25), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
    }


    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let duration: Float = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Float, let curve: Float = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Float {

            textBackgroundBottomConstraint.constant = 0
            UIViewPropertyAnimator(duration: TimeInterval(duration), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(curve))!) {
                self.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
    
    
    //MARK: TEXT VIEW BEGIN EDITING
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.label
        }
    }
    
    
    //MARK: TEXT VIEW END EDITING
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type an item"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProperties" {
            let dest = segue.destination as! CollectionPropertiesViewController
            dest.collection = self.collection
        } else if segue.identifier == "showCheck" {
            let dest = segue.destination as! CheckViewController
            dest.collection = self.collection
            dest.items = self.items.filter({ (item) -> Bool in
                return item.checked != nil
            })
            dest.confirmState = true
        }
    }
    

}



extension CollectionViewController: UITableViewDataSource, UITableViewDelegate, ItemTableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == itemsTableView {
            return items.count
        }
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == itemsTableView {
            let item = items[indexPath.row]
            if item.count == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "itemSmallCell", for: indexPath) as! ItemSmallTableViewCell
                cell.titleLabel.text = item.name
                cell.priceLabel.text = item.price >= 0 ? "\(item.price)₸" : ""
                cell.indexPath = indexPath
                cell.delegate = self
                cell.currentState = .normal
                cell.checkButton.setImage(UIImage(systemName: item.checked == nil ? "circle" : "checkmark.circle.fill"), for: .normal)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "itemLargeCell", for: indexPath) as! ItemLargeTableViewCell
                cell.titleLabel.text = item.name
                cell.priceLabel.text = item.price >= 0 ? "\(item.price)₸" : ""
                cell.countLabel.text = "\(item.count)"
                cell.indexPath = indexPath
                cell.delegate = self
                cell.currentState = .normal
                cell.checkButton.setImage(UIImage(systemName: item.checked == nil ? "circle" : "checkmark.circle.fill"), for: .normal)
                
                return cell
            }
        } else {
            let item = filteredItems[indexPath.row]
            if item.1 == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "itemSmallCell", for: indexPath) as! ItemSmallTableViewCell
                cell.titleLabel.text = item.0
                cell.priceLabel.text = item.2 >= 0 ? "\(item.2)₸" : ""
                cell.indexPath = indexPath
                cell.delegate = self
                cell.currentState = .choose
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "itemLargeCell", for: indexPath) as! ItemLargeTableViewCell
                cell.titleLabel.text = item.0
                cell.priceLabel.text = item.2 >= 0 ? "\(item.2)₸" : ""
                cell.countLabel.text = "\(item.1)"
                cell.indexPath = indexPath
                cell.delegate = self
                cell.currentState = .choose
                
                
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView {
            textView.text = "Type an item"
            textView.textColor = .lightGray
//            items.append(filteredItems[indexPath.row])
            searchViewHeightConstraint.constant = 0
            searchViewBottomConstraint.constant = -36
            searchView.layer.shadowColor = UIColor.clear.cgColor
            UIViewPropertyAnimator(duration: TimeInterval(0.5), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
                self.view.layoutIfNeeded()
            }.startAnimation()
            filteredItems = []
            searchTableView.reloadData()
            itemsTableView.reloadData()
            view.endEditing(true)
        } else {
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func optionsPressed(_ indexPath: IndexPath, _ state: ItemSmallTableViewCell.itemState) {
        print(items, indexPath)
        selectedItem = items[indexPath.row]
        
        let actionSheet = UIAlertController(title: selectedItem?.name, message: nil, preferredStyle: .actionSheet)
        let picker = UIPickerView(frame: CGRect(x: 0, y: 158, width: actionSheet.view.bounds.size.width - 16, height: 232))
        picker.backgroundColor = UIColor.systemBackground
        picker.layer.cornerRadius = 14
//        picker.selectedRow(inComponent: selectedItem?.count ?? 0)
        picker.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        picker.delegate = self
        picker.dataSource = self
        actionSheet.view.addSubview(picker)

        actionSheet.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { (action) in
            self.selectedItem?.update(completion: { (arg0) -> Void in
                self.selectedItem = nil
            })
            self.itemsTableView.reloadRows(at: [indexPath], with: .automatic)
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func checkPressed(_ indexPath: IndexPath, _ state: ItemSmallTableViewCell.itemState) {
        if state == .normal {
            items[indexPath.row].check()
            itemsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


extension CollectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem?.count = row + 1
    }
}



