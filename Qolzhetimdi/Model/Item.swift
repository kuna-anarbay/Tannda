//
//  Item.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Item {
    
    var id: String = ""
    var priority: Int = 0
    var name: String = ""
    var barCode: String = ""
    var image: String = ""
    var priceCount: Int = 1
    var priceSum: Int = 0
    var pricePer: String = ""
    var priceValue: Int = 0
    
    init() {
        
    }
    
    init(_ document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.name = document.data()["name"] as! String
        self.priority = document.data()["priority"] as? Int ?? 0
        self.barCode = document.data()["barcode"] as? String ?? ""
        self.image = document.data()["image"] as? String ?? ""
        
        if let price = document.data()["price"] as? [String: Int] {
            self.priceCount = price["count"] ?? 1
            self.priceSum = price["sum"] ?? 0
        }
    }
    
    init(at shopDocument: QueryDocumentSnapshot) {
        self.id = shopDocument.documentID
        self.name = shopDocument.data()["name"] as! String
        self.barCode = shopDocument.data()["barcode"] as? String ?? ""
        self.image = shopDocument.data()["image"] as? String ?? ""
        
        if let price = shopDocument.data()["price"] as? [String: Any] {
            self.pricePer = price["per"] as? String ?? ""
            self.priceValue = price["value"] as? Int ?? 0
        }
    }
    
    static func getAll(_ name: String, completion: @escaping([Item]) -> Void) {
        Constants.itemsRef.whereField("name", isGreaterThanOrEqualTo: name).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                var items = [Item]()
                for document in snapshot.documents {
                    items.append(Item(document))
                }
                completion(items)
            } else {
                completion([])
            }
        }
    }
    
    static func getShopItem(_ id: String, completion: @escaping([Item]) -> Void) {
        Constants.shopsRef.document(id).collection("items").addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                var items = [Item]()
                for document in snapshot.documents {
                    items.append(Item(at: document))
                }
                completion(items)
            } else {
                completion([])
            }
        }
    }
}
