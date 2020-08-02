//
//  Review.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase


class Review {
    
    var id: String = ""
    var author: Member = Member()
    var date: Timestamp = Timestamp()
    var body: String = ""
    var rating: Int = 1
    var replyBody: String = ""
    var replyDate: Timestamp? = nil
    var images: [String] = [String]()
    var files: [UIImage] = [UIImage]()
    
    init(){
        
    }
    
    init(_ document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let data = document.data()
        self.body = data["body"] as! String
        self.rating = data["rating"] as! Int
        self.images = data["images"] as? [String] ?? []
        
        if let author = data["author"] as? [String: String] {
            self.author.avatar = author["avatar"]
            self.author.uid = document.documentID
            self.author.name = author["name"] ?? ""
        }
        
        if let reply = data["reply"] as? [String: Any] {
            self.replyBody = reply["body"] as! String
            self.replyDate = reply["date"] as? Timestamp
        }
    }
    
    func create(_ id: String, completion: @escaping((feedBack, String)) -> Void) {
        let currentUser = Auth.auth().currentUser!
        Helper.uploadImages(
            storageRef: Constants.storageRef.child("shops/" + id + "/reviews/" + currentUser.uid),
            childs: Array(0..<self.files.count).map({ (index) -> String in
                return "\(index)"
            }),
            images: files,
            index: 0,
            image_urls: [:]
        ) { (results) in
            self.images = results.map { (args) -> String in
                return args.value
            }
            Constants.shopsRef.document(id).collection("reviews").document(currentUser.uid).setData([
                "body": self.body,
                "date": self.date,
                "rating": self.rating,
                "author": [
                    "name": currentUser.displayName as Any,
                    "avatar": currentUser.photoURL as Any
                ],
                "images": self.images
            ]) { (error) in
                if error == nil {
                    completion((.success, "Successfully created"))
                } else {
                    completion((.error, "Failed to create"))
                }
            }
        }
    }
    
    func delete(_ id: String, completion: @escaping((feedBack, String)) -> Void) {
        let currentUser = Auth.auth().currentUser!
        Constants.shopsRef.document(id).collection("reviews").document(currentUser.uid)
            .delete(completion: { (error) in
            if error == nil {
                completion((.success, "Successfully deleted"))
            } else {
                completion((.error, "Failed to delete"))
            }
        })
    }
    
    static func getAll(_ id: String, filterBy: Int? = nil, completion: @escaping([Review]) -> Void) {
        if let rating = filterBy {
            Constants.shopsRef.document(id).collection("reviews").whereField("rating", isEqualTo: rating)
                .getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    var reviews = [Review]()
                    for document in snapshot.documents {
                        reviews.append(Review(document))
                    }
                    completion(reviews)
                } else {
                    completion([])
                }
            }
        } else {
            Constants.shopsRef.document(id).collection("reviews").getDocuments { (snapshot, error) in
                if let snapshot = snapshot {
                    var reviews = [Review]()
                    for document in snapshot.documents {
                        reviews.append(Review(document))
                    }
                    completion(reviews)
                } else {
                    completion([])
                }
            }
        }
    }
}
