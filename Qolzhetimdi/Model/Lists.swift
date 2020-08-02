//
//  Lists.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

public enum feedBack {
    case error
    case success
}

struct Constants {
    
    static let storageRef = Storage.storage().reference()
    
    static let collectionsRef = Firestore.firestore().collection("collections")
    static let itemsRef = Firestore.firestore().collection("items")
    static let usersRef = Firestore.firestore().collection("users")
    static let historyRef = Firestore.firestore().collection("history")
    static let shopsRef = Firestore.firestore().collection("shops")
    static let questionsRef = Firestore.firestore().collection("questions")
    static let faqsRef = Firestore.firestore().collection("faqs")
}


struct lists {
    
    static let days : [String] = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    
    static let icons : [String] = ["list.bullet", "bookmark.fill", "mappin", "gift.fill", "book.fill", "creditcard.fill", "bitcoinsign.square.fill", "paperplane.fill", "trash.fill", "square.and.pencil", "person.fill", "gamecontroller.fill", "house.fill", "desktopcomputer", "music.note", "folder.fill", "tram.fill", "moon.fill", "sun.min.fill", "snow", "car", "cart.fill", "bag.fill", "gear", "chevron.left.slash.chevron.right", "circle.fill", "waveform.path.ecg", "heart.fill", "star.fill", "flame.fill"]
    
    static let colors : [String] = ["#00A89D", "#2887CA", "#D95F4C", "#8F7AC5", "#888DA6", "#FFC659", "#1C8E86", "#0085E3", "#F24024", "#825DDE", "#57608C", "#F6971F"]
    
}

struct Helper {
    
    //MARK: Compress image to 100KB
    static func compressImage(_ image: UIImage) -> Data? {
        
        //Initialize compressing parameters
        var compression : CGFloat = 1
        let maxCompression : CGFloat = 0.0
        let maxFileSize : Int = 100*1024
        
        //Get longer size
        let max = (image.size.width > image.size.height) ? image.size.width : image.size.height
        
        //TODO: Resize image to 1280px
        var result = image
        if max > 1280 {
            result = image.resizeWithPercent(percentage: 1280/max)!
        } else {
            result = image
        }
        
        //TODO: Compress resized image to 100KB
        var imageData = result.jpegData(compressionQuality: compression)
        while (imageData!.count > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = image.jpegData(compressionQuality: compression)
        }
        
        return imageData
    }
    
    //MARK: Upload all images
    static func uploadImages(
        storageRef: StorageReference,                   //Storage reference
        childs: [String],                               //Children storage references
        images: [UIImage],                              //Uploading images
        index: Int,                                     //Index of current image in images
        image_urls: [String: String],                   //Urls of images to save to Database
        completion: @escaping([String: String]) -> Void //Completion handler
    ){
        if images.count == index {                      //End of recursion
            completion(image_urls)                      //Return all urls
        } else {
            let data = compressImage(images[index])     //Compressed data
            
            if let image = data {                       //Compression success
                
                //Uploading data to Storage
                storageRef.child(childs[index]).putData(image, metadata: nil) { (meta, error) in
                    if error != nil {                   //Uploading error, return values
                        completion(image_urls)
                    } else {                            //Uploading success
                        //Get downloadURL of uploaded data
                        storageRef.child(childs[index]).downloadURL { (downloadURL, error) in
                            if let url = downloadURL {  //Download url success
                                
                                //Append url to urls list
                                var urls : [String: String] = [ childs[index] : "\(url)" ]
                                for image in image_urls {
                                    urls[image.key] = image.value
                                }
                                
                                //Upload next image
                                self.uploadImages(
                                    storageRef: storageRef,
                                    childs: childs,
                                    images: images,
                                    index: index + 1,
                                    image_urls: urls,
                                    completion: completion
                                )
                            } else {                    //Download url error
                                completion(image_urls)
                            }
                        }
                    }
                }
            } else {
                completion(image_urls)              //Compression error occurred
            }
        }
    }
}
