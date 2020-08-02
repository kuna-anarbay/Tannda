//
//  NewReviewViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/12/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit
import AssetsPickerViewController
import Photos

class NewReviewViewController: UIViewController, UITextViewDelegate, AssetsPickerViewControllerDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var starsStackView: UIStackView!
    var review = Review()
    var shop = Shop()
    let picker = AssetsPickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.hideKeyboardWhenTappedAround()
        setDesign()
        textView.delegate = self
        picker.pickerDelegate = self
    }
    
    func setDesign(){
        for i in 0..<5 {
            if review.rating > i {
                starsStackView.viewWithTag(i+1)?.tintColor = UIColor.systemYellow
            } else {
                starsStackView.viewWithTag(i+1)?.tintColor = UIColor.systemGray2
            }
        }
    }
    
    @IBAction func starPressed(_ sender: UIButton) {
        self.review.rating = sender.tag
        setDesign()
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            review.body = text
            review.create(self.shop.id) { (arg0) in
                if arg0.0 == .success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    
                }
            }
        }
    }
    

    @IBAction func uploadPressed(_ sender: Any) {
        picker.pickerConfig.assetsMaximumSelectionCount = 3
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        var frame = self.textView.frame
        frame.size.height = self.textView.contentSize.height
        textViewHeight.constant = min(frame.height + 24, 200)
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



extension NewReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageCollectionViewCellDelegate {
    
    
    func select(_ indexPath: IndexPath) {
    
    }
    
    
    
    func remove(_ indexPath: IndexPath) {
        review.files.remove(at: indexPath.row)
        if review.files.count == 0 {
            uploadButton.setTitle("Upload images", for: .normal)
        } else {
            uploadButton.setTitle("\(review.files.count) images selected", for: .normal)
        }
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return review.files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.delegate = self
        cell.imageView.image = review.files[indexPath.row]
        cell.indexPath = indexPath
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height)
    }
    
    
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        review.files = assets.map({$0.getAssetThumbnail()})
        if review.files.count == 0 {
            uploadButton.setTitle("Upload images", for: .normal)
        } else {
            uploadButton.setTitle("\(review.files.count) images selected", for: .normal)
        }
        self.collectionView.reloadData()
    }
    
    
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {
        review.files = []
        uploadButton.setTitle("Upload images", for: .normal)
        self.collectionView.reloadData()
    }
}


