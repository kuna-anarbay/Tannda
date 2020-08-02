//
//  Collection.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/7/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase


class Collection {
    
    var id: String = ""
    var title: String = ""
    var icon: String = lists.icons.randomElement() ?? lists.icons[0]
    var color: String = lists.colors.randomElement() ?? lists.colors[0]
    var sum: Int = 0
    var count: Int = 0
    var date: Timestamp = Timestamp()
    var shopId: String? = nil
    var shopName: String? = nil
    var branchId: String? = nil
    var isAccepted: Bool = false
    var members: [Member] = [Member]()
    var newRepresentation: [String: Any] {[
        "title": self.title,
        "icon": self.icon,
        "color": self.color,
        "date": Date(),
        "shop": [
            "id": self.shopId,
            "branchId": self.branchId,
            "name": self.shopName
        ],
        "members": members.reduce([Int: Member](), { (dict, member) -> [String: Any] in
            return member.memberRepresentation
        })
    ]}
    var updateRepresentation: [String: Any] {[
        "title": self.title,
        "icon": self.icon,
        "color": self.color,
        "date": Date()
    ]}
    
    
    init(){
            
    }
    
    init(_ document: QueryDocumentSnapshot) {
        
        self.id = document.documentID
        let data = document.data()
        self.title = data["title"] as! String
        self.icon = data["icon"] as! String
        self.color = data["color"] as! String
        self.sum = data["sum"] as? Int ?? 0
        self.count = data["count"] as? Int ?? 0
        self.date = data["date"] as? Timestamp ?? Timestamp()
        
        if let shop = data["shop"] as? [String: String] {
            self.shopId = shop["id"]
            self.branchId = shop["branchId"]
            self.shopName = shop["title"]
        }
        
        if let members = data["members"] as? [String: Any] {
            for member in members {
                let newMember = Member(member.key, member.value)
                if newMember.uid == Auth.auth().currentUser?.uid {
                    self.isAccepted = newMember.accepted
                }
                self.members.append(newMember)
            }
        }
    }
    
    init(_ document: DocumentSnapshot) {
        
        self.id = document.documentID
        let data = document.data()!
        self.title = data["title"] as! String
        self.icon = data["icon"] as! String
        self.color = data["color"] as! String
        self.sum = data["sum"] as? Int ?? 0
        self.count = data["count"] as? Int ?? 0
        self.date = data["date"] as? Timestamp ?? Timestamp()
        
        if let branch = data["branch"] as? [String: String] {
            self.shopId = branch["id"]
            self.branchId = branch["branchId"]
            self.shopName = branch["title"]
        }
        
        if let members = data["members"] as? [String: Any] {
            for member in members {
                let newMember = Member(member.key, member.value)
                if newMember.uid == Auth.auth().currentUser?.uid {
                    self.isAccepted = newMember.accepted
                }
                self.members.append(newMember)
            }
        }
    }
    
    
    func create(completion: @escaping((feedBack, String?)) -> Void) {
        self.members.append(Member.currentUser)
        Constants.collectionsRef.addDocument(data: newRepresentation) { (error) in
            if error != nil {
                completion((.error, "Failed to create"))
            } else {
                completion((.success, "Successfully created"))
            }
        }
    }
    
    func update(completion: @escaping((feedBack, String?)) -> Void) {
        Constants.collectionsRef.document(self.id).updateData(updateRepresentation) { (error) in
            if error != nil {
                completion((.error, "Failed to update"))
            } else {
                completion((.success, "Successfully updated"))
            }
        }
    }
    
    func delete(completion: @escaping((feedBack, String?)) -> Void) {
        Constants.collectionsRef.document(self.id).delete { (error) in
            if error != nil {
                completion((.error, "Failed to delete"))
            } else {
                completion((.success, "Successfully deleted"))
            }
        }
    }
    
    static func getAll(completion: @escaping([Collection]) -> Void) {
        let uid = (Auth.auth().currentUser?.uid ?? "GuS4v9eJ5vCvqzNVBMQr")
        Constants.collectionsRef.whereField("members." + uid + ".accepted", isEqualTo: true).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                var collections = [Collection]()
                for document in snapshot.documents {
                    collections.append(Collection(document))
                }
                completion(collections)
            } else {
                completion([])
            }
        }
    }
    
    
    func getThis(completion: @escaping(Collection) -> Void) {
        Constants.collectionsRef.document(self.id).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                completion(Collection(snapshot))
            } else {
                completion(self)
            }
        }
    }
    
}


class Member {
    var uid: String = ""
    var name: String = ""
    var avatar: String? = ""
    var accepted: Bool = false
    var memberRepresentation: [String: [String: Any]] {[
        uid: [
            "name": self.name,
            "avatar": self.avatar as Any,
            "accepted": false
        ]
    ]}
    static var currentUser: Member {
        get {
            let member = Member()
            member.uid = Auth.auth().currentUser!.uid
            member.name = Auth.auth().currentUser!.displayName ?? Auth.auth().currentUser!.phoneNumber!
            member.avatar = Auth.auth().currentUser!.photoURL != nil ? Auth.auth().currentUser!.photoURL!.absoluteString : nil
            member.accepted = true
            
            return member
        }
    }
    
    
    init() {
        
    }
    
    init(_ key: String, _ value: Any) {
        self.uid = key
        
        let val = value as! [String: Any]
        self.name = val["name"] as! String
        self.avatar = val["avatar"] as? String
        self.accepted = val["accepted"] as! Bool
    }
}
