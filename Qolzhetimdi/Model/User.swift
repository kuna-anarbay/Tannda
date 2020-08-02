//
//  User.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var id: String = ""
    var displayName: String = ""
    var avatar: String = ""
    var phone: String = ""
    var authCode: Int = 0
    var authExpiration: Date = Date()
    var role: String? = nil
    
    
    init() {
        
    }
    
    init(_ document: QueryDocumentSnapshot){
        self.id = document.documentID
        self.displayName = document.data()["name"] as? String ?? ""
        self.phone = document.data()["phone"] as? String ?? ""
        self.avatar = document.data()["avatar"] as? String ?? ""
    }
    
    static func currentUser(completion: @escaping(FirebaseAuth.User?) -> Void){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            completion(user)
        }
    }
    
    static func updateProfile(_ displayName: String?, _ phoneNumber: String?, _ url: URL?){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        if displayName != nil && displayName != Auth.auth().currentUser?.displayName {
            changeRequest?.displayName = displayName
        }
        changeRequest?.commitChanges { (error) in
            print("Profile updated")
        }
    }
    
    
    static func getFriends(_ phoneNumbers: [String], completion: @escaping([User]) -> Void) {
        Constants.usersRef.whereField("phone", in: phoneNumbers).addSnapshotListener { (snapshot, error) in
            if let snapshot = snapshot {
                var users = [User]()
                
                for document in snapshot.documents {
                    users.append(User(document))
                }
                
                completion(users)
            } else {
                completion([])
            }
        }
    }
}
