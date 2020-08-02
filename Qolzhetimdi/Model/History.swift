//
//  History.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase


class History {
    
    var id: String = ""
    var collectionId: String = ""
    var date: Timestamp = Timestamp()
    var shopId: String? = nil
    var shopName: String? = nil
    var branchId: String? = nil
    var author: Member = Member()
    var items: [CollectionItem] = [CollectionItem]()
    
    
    init(){
        
    }
    
    init(_ document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let data = document.data()
        
        self.collectionId = data["collectionId"] as! String
        self.date = data["date"] as? Timestamp ?? Timestamp()
        if let shop = data["shop"] as? [String: String] {
            self.shopId = shop["id"]
            self.branchId = shop["branchId"]
            self.shopName = shop["title"]
        }
        if let author = data["author"] as? [String: Any] {
            self.author.uid = author["uid"] as! String
            self.author.name = author["name"] as! String
            self.author.avatar = author["avatar"] as? String
        }
        if let temp = data["items"] as? NSDictionary {
            for item in temp {
                self.items.append(CollectionItem(item.key as! String, item.value as! [String: Any]))
            }
        }
    }
    
    static func create(_ collection: Collection, _ items: [CollectionItem], completion: @escaping((feedBack, String?)) -> Void) {
        Constants.historyRef.addDocument(data: [
            "collectionId": collection.id,
            "shop": [
                "id": collection.shopId,
                "branchId": collection.branchId,
                "name": collection.shopName
            ],
            "author": [
                "uid": Auth.auth().currentUser?.uid as Any,
                "name": Auth.auth().currentUser?.displayName as Any,
                "avatar": Auth.auth().currentUser?.photoURL as Any
            ],
            "items": items.reduce([String: Any](), { (dict, item) -> [String: Any] in
                var dict = dict
                dict[item.id] = [
                    "name": item.name,
                    "price": item.price,
                    "count": item.count
                ]
                return dict
            }),
            "date": Date()
        ])  { (error) in
            if error != nil {
                completion((.error, "Failed to create"))
            } else {
                completion((.success, "Successfully created"))
            }
        }
    }
    
    
    static func getAll(_ collectionIds: [String], completion: @escaping([History]) -> Void) {
        Constants.historyRef.whereField("collectionId", in: collectionIds).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                var history = [History]()
                for document in snapshot.documents {
                    history.append(History(document))
                }
                completion(history)
            } else {
                completion([])
            }
        }
    }
    
    
    static func getAll(_ id: String, completion: @escaping([History]) -> Void) {
        Constants.historyRef.whereField("collectionId", isEqualTo: id).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                var history = [History]()
                for document in snapshot.documents {
                    history.append(History(document))
                }
                completion(history)
            } else {
                completion([])
            }
        }
    }
    
}
