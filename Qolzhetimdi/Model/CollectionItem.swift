//
//  CollectionItem.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class CollectionItem {
    
    var id: String = ""
    var collectionId: String = ""
    var author: String = Member.currentUser.uid
    var name: String = ""
    var checked: Timestamp? = nil
    var checkAuthor: String? = nil
    var image: String = ""
    var price: Int = 0
    var count: Int = 0
    var newRepresentation: [String: Any] {[
        "name": self.name,
        "price": self.price,
        "count": self.count,
        "author": self.author
    ]}
    var updateRepresentation: [String: Any] {[
        "count": self.count,
    ]}
    
    init(){
            
    }
    
    init(_ key: String, _ history: [String: Any]){
        self.id = key
        self.name = history["name"] as! String
        self.price = history["price"] as! Int
        self.count = history["count"] as! Int
    }
    
    init(_ name: String, _ price: Int = -1, _ count: Int = 1) {
        print(name)
        self.name = name
        self.price = price
        self.count = count
    }
    
    init(_ id: String, _ document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        
        self.name = document.data()["name"] as! String
        self.collectionId = id
        self.author = document.data()["author"] as! String
        self.price = document.data()["price"] as? Int ?? 0
        self.count = document.data()["count"] as? Int ?? 0
        
        if let checked = document.data()["checked"] as? [String: Any] {
            self.checked = checked["date"] as? Timestamp
            self.checkAuthor = checked["uid"] as? String
        }
    }
    
    
    func check() {
        if self.checked == nil {
            Constants.collectionsRef.document(self.collectionId).collection("items").document(self.id).updateData([
                "checked": [
                    "uid": Auth.auth().currentUser?.uid as Any,
                    "date": Date()
                ]
            ])
        } else {
            Constants.collectionsRef.document(self.collectionId).collection("items").document(self.id).updateData([
                "checked": [
                    "uid": nil,
                    "date": nil
                ]
            ])
        }
    }
    
    func create(_ id: String, completion: @escaping((feedBack, String?)) -> Void){
        Constants.collectionsRef.document(id).collection("items").addDocument(data: self.newRepresentation) { (error) in
            if error != nil {
                completion((.error, "Failed to add"))
            } else {
                completion((.success, "Successfully added"))
            }
        }
    }
    
    
    func update(completion: @escaping((feedBack, String?)) -> Void){
        Constants.collectionsRef.document(id).collection("items").document(self.id)
            .updateData(self.updateRepresentation) { (error) in
            if error != nil {
                completion((.error, "Failed to add"))
            } else {
                completion((.success, "Successfully added"))
            }
        }
    }
    
    static func getAll(_ id: String, completion: @escaping([CollectionItem]) -> Void){
        Constants.collectionsRef.document(id).collection("items").addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                var items = [CollectionItem]()
                for document in snapshot.documents {
                    items.append(CollectionItem(id, document))
                }
                completion(items.sorted(by: { (item1, item2) -> Bool in
                    return item1.id > item2.id
                }))
            } else {
                completion([])
            }
        }
    }
    
    
    
    
}
