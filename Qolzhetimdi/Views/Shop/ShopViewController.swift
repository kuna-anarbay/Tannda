//
//  ShopViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import Lightbox


class ShopViewController: UIViewController {

    enum shopView {
        case details
        case items
        case reviews
    }
    var currentView: shopView = .details
    
    @IBOutlet weak var segmentedControlBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleBackground: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    var filters: [String] = ["One", "Two", "Three", "Four", "Five", "None"]
    var branches: [String] = ["Kuna","Kuna", "Kuna", "Kuna", "Kuna"]
    var shop = Shop()
    var items = [Item]()
    var reviews = [Review]()
    var aboutExpanded = false
    var filterBy = 6
    var lastContentOffset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        rightBarButton.title = ""
        self.mainImage.layer.cornerRadius = 8
        self.fetchData()
        self.fetchItems()
        self.fetchReviews()
        
        self.navigationItem.title = "Shop name"
        
        let nib = UINib(nibName: "SectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func fetchData(){
        shop.getThis { (shop) in
            self.shop = shop
            self.setData()
        }
    }
    
    func setData(){
        self.backgroundImage.setImage(from: URL(string: shop.background))
        self.mainImage.setImage(from: URL(string: shop.logo))
        self.shopName.text = shop.name
        self.timeLabel.text = shop.todayOpen
        
        self.tableView.reloadData()
    }
    
    func fetchItems(){
        Item.getShopItem(shop.id) { (items) in
            self.items = items
            if self.currentView == .items {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchReviews(){
        if filterBy == 6 {
            Review.getAll(shop.id) { (reviews) in
                self.reviews = reviews
                if self.currentView == .reviews {
                    self.tableView.reloadData()
                }
            }
        } else {
            Review.getAll(shop.id, filterBy: filterBy) { (reviews) in
                self.reviews = reviews
                if self.currentView == .reviews {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func righButtonPressed(_ sender: Any) {
        if currentView == .reviews {
            self.performSegue(withIdentifier: "newReview", sender: nil)
        } else if currentView == .items {
            
        }
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentChanges(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentView = .details
            rightBarButton.title = ""
            backgroundTopConstraint.constant = 0
            tableViewTopConstraint.constant = 0
            self.navigationController?.navigationBar.isHidden = true
        } else {
            if sender.selectedSegmentIndex == 1 {
                currentView = .items
                rightBarButton.title = "Filter"
            } else {
                currentView = .reviews
                rightBarButton.image = UIImage(systemName: "square.and.pencil")
            }
            let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            backgroundTopConstraint.constant = -(self.tableView.frame.width*4/5 - height - 44)
            tableViewTopConstraint.constant = -(self.tableView.frame.width*4/5 + 72)
            self.navigationController?.navigationBar.isHidden = false
        }
        tableView.reloadData()
        
        UIViewPropertyAnimator(duration: TimeInterval(1), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newReview" {
            let dest = segue.destination as! NewReviewViewController
            dest.shop = self.shop
        }
    }
    

}

extension ShopViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentView == .details {
            let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            backgroundTopConstraint.constant = -scrollView.contentOffset.y
            if scrollView.contentOffset.y > background.frame.height - (124 + height) {
                self.navigationController?.navigationBar.isHidden = false
            } else {
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.lastContentOffset - scrollView.contentOffset.y > 64) {
            segmentedControlBottomConstraint.constant = -64
        } else if (scrollView.contentOffset.y - self.lastContentOffset > 64) {
            segmentedControlBottomConstraint.constant = 16
        }
        UIViewPropertyAnimator(duration: TimeInterval(1), curve: UIView.AnimationCurve(rawValue: UIView.AnimationCurve.RawValue(7.0))!) {
            self.view.layoutIfNeeded()
        }.startAnimation()
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentView {
        case .details:
            return 5
        case .items:
            return 2
        case .reviews:
            return reviews.count + 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentView {
        case .details:
            if section == 0 {
                return 2
            } else if section == 2 {
                return shop.contacts.count
            } else if section == 3 {
                return shop.branches.count
            } else {
                return 1
            }
        case .items:
            if section == 0 {
                return 2
            }
            return items.count
        case .reviews:
            switch section {
            case 0:
                return 2
            case 1:
                return 1
            case 2:
                return 1
            default:
                let review = reviews[section - 3]
                if review.images.count > 0 && review.replyDate != nil {
                    return 3
                }
                if review.replyDate != nil {
                    return 2
                }
                if review.images.count > 0 {
                    return 2
                }
                return 1
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)
            
            return cell
        } else if indexPath.section == 0 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath) as! ShopTopTableViewCell
            
            cell.branchesLabel.text = "\(shop.branches.count)"
            cell.itemsLabel.text = "\(shop.itemsCount)"
            cell.ratingLabel.text = "\(shop.getRating)"
            cell.workingHourLabel.text = shop.todayOpen
            
            return cell
        }
        
        switch currentView {
        case .details:
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
                
                if shop.about.count > 140 {
                    if aboutExpanded {
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: shop.about)
                        let attrString = NSMutableAttributedString(string: " Show less")
                        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: NSMakeRange(0, attrString.length))
                        attributeString.append(attrString)
                        cell.textLabel?.attributedText = attributeString
                    } else {
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(shop.about.prefix(140)))
                        let attrString = NSMutableAttributedString(string: " Show more")
                        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: NSMakeRange(0, attrString.length))
                        attributeString.append(attrString)
                        cell.textLabel?.attributedText = attributeString
                    }
                } else {
                    cell.textLabel?.text = shop.about
                }
                
                
                return cell
            } else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ShopContactTableViewCell
                let contact = shop.contacts[indexPath.row]
                cell.iconImage.image = UIImage(systemName: "clock")
                cell.phoneLabel.text = contact.data
                cell.detailsLabel.text = contact.type
                
                return cell
            } else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ShopContactTableViewCell
                let branch = shop.branches[indexPath.row]
                cell.iconImage.image = UIImage(systemName: "mappin.and.circle")
                cell.phoneLabel.text = branch.adress
//                cell.detailsLabel.text = contact.type
                
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCell", for: indexPath) as! MediaTableViewCell
                cell.media = shop.socialMedia
                
                return cell
            }
        case .items:
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
            let item = items[indexPath.row]
            
            cell.titleLabel.text = item.name
            cell.countLabel.text = "\(item.priceValue)₸/\(item.pricePer)"
            cell.mainImage.setImage(from: URL(string: item.image))
            
            
            return cell
        case .reviews:
            switch indexPath.section {
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! RatingTableViewCell
                cell.shop = shop
                
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath)
                cell.textLabel?.text = "Sorted by"
                cell.detailTextLabel?.text = filters[filterBy - 1]
                
                return cell
            default:
                let review = reviews[indexPath.section - 3]
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "reviewBodyCell", for: indexPath) as! ReviewTableViewCell
                    cell.review = review
                    
                    return cell
                } else if indexPath.row == 1 && review.images.count > 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "reviewImageCell", for: indexPath) as! ReviewImageTableViewCell
                    cell.review = review
                    cell.delegate = self
                    cell.reviewIndexPath = indexPath
                    
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "reviewReplyCell", for: indexPath) as! ReviewReplyTableViewCell
                    cell.review = review
                    
                    return cell
                }
            }
            
        }
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentView == .details {
            if indexPath.section == 1 {
                self.aboutExpanded = !self.aboutExpanded
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else if currentView == .reviews && indexPath.section == 2 {
            self.filter()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let height = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                return self.tableView.frame.width*4/5 - 55 + height
            }
            return 64
        }
        switch currentView {
        case .details:
            if indexPath.section == 1 {
                return UITableView.automaticDimension
            } else if indexPath.section == 2 {
                return 60
            } else if indexPath.section == 3 {
                return 60
            } else {
                return 64
            }
        case .items:
            return 72
        case .reviews:
            switch indexPath.section {
            case 1:
                return 104
            case 2:
                return 44
            default:
                let review = reviews[indexPath.section - 3]
                if indexPath.row == 1 && review.images.count > 0 {
                    return 200
                }
                return UITableView.automaticDimension
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if currentView == .details {
            let sectionHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! SectionHeader
            
            switch section {
            case 1:
                sectionHeader.titleLabel.text = "About"
                break
            case 2:
                sectionHeader.titleLabel.text = "Contact Us"
                break
            case 3:
                sectionHeader.titleLabel.text = "Branches"
                break
            default:
                sectionHeader.titleLabel.text = "Social media"
                break
            }
            
            sectionHeader.detailLabel.text = ""
            
            return sectionHeader
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentView == .details && section != 0 {
            return 38
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    func filter(){
        let alert = UIAlertController(title: "Filter reviews", message: nil, preferredStyle: .actionSheet)
        let temp = filters.reversed()
        for i in 0..<temp.count {
            alert.addAction(UIAlertAction(title: filters[i], style: .default, handler: { (_) in
                self.filterBy = i + 1
                self.fetchReviews()
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



extension ShopViewController: ImageCollectionViewCellDelegate, LightboxControllerDismissalDelegate, LightboxControllerPageDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
    
    func remove(_ indexPath: IndexPath) {
        
    }
    
    func select(_ indexPath: IndexPath) {
        print(reviews, indexPath)
        let images = reviews[indexPath.section - 3].images.map({ LightboxImage(imageURL: URL(string: $0)!)})
        let controller = LightboxController(images: images)
        controller.dynamicBackground = true
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }
    
    
}
