//
//  NewCollectionViewController.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


class NewCollectionViewController: UIViewController {

    
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var styleBackground: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var colorView: UIView!
    var newCollection = Collection()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 30
        titleField.layer.cornerRadius = 12
        separatorLine.backgroundColor = UIColor.clear
        titleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: titleField.bounds.height))
        titleField.leftViewMode = .always
        
        titleField.becomeFirstResponder()
        setStyle()
    }
    
    func setStyle() {
        iconImage.image = UIImage(systemName: newCollection.icon)
        iconImage.tintColor = UIColor(hexString: newCollection.color)
        colorView.backgroundColor = UIColor(hexString: newCollection.color).withAlphaComponent(0.15)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if let text = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            let alert = self.loadingAlert()
            self.present(alert, animated: true, completion: nil)
            
            newCollection.title = text
            newCollection.create { (arg0) in
                alert.dismiss(animated: true, completion: nil)
                let (status, message) = arg0
                if status == .error {
                    print(message)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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


extension NewCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 10 {
            separatorLine.backgroundColor = UIColor.opaqueSeparator
        } else {
            separatorLine.backgroundColor = UIColor.clear
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 38
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListItemCollectionViewCell
            if indexPath.row == 0 {
                cell.titleLabel.text = "Shop"
            } else {
                cell.titleLabel.text = "Shared with"
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "styleCell", for: indexPath) as! StyleCollectionViewCell
            
            if indexPath.row <= 13 {
                cell.iconImage.image = nil
                cell.contentView.backgroundColor = UIColor(hexString: lists.colors[indexPath.row - 2])
                cell.checkedBackground.isHidden = newCollection.color != lists.colors[indexPath.row - 2]
            } else {
                cell.iconImage.image = UIImage(systemName: lists.icons[indexPath.row - 14])
//                cell.background.backgroundColor = UIColor.green
                cell.checkedBackground.isHidden = newCollection.icon != lists.icons[indexPath.row - 14]
            }
            
//            cell.contentView.backgroundColor = .green
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            self.performSegue(withIdentifier: "showList", sender: nil)
        } else if indexPath.row > 1 && indexPath.row <= 13 {
            newCollection.color = lists.colors[indexPath.row - 2]
        } else {
            newCollection.icon = lists.icons[indexPath.row - 14]
        }
        setStyle()
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row < 2 {
            return CGSize(width: collectionView.bounds.width, height: 66)
        } else {
            let width = self.view.bounds.width - 16
            return CGSize(width: width / 6, height: width / 6)
        }
    }
    
}


extension NewCollectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let title = textField.text, title.count > 0 {
            self.view.endEditing(true)
        }
        
        return true
    }
    
}
