//
//  Question.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class Question {
    
    var id: String = ""
//    var author: User = User()
    var date: Timestamp = Timestamp()
    var body: String = ""
    var replyBody: String = ""
    var replyDate: Timestamp = Timestamp()
    var newRepresentation: [String: Any] {[
//        "author": self.author,
        "date": Timestamp(),
        "body": self.body,
        "reply": [
            "replyBody": self.replyBody,
            "replyDate": self.replyDate
        ]
    ]}
    
    init() {
        
    }
    
    func create(completion: @escaping((feedBack, String)) -> Void) {
        Constants.questionsRef.addDocument(data: newRepresentation) { (error) in
            if error != nil {
                completion((.error, "Failed to add question to db."))
            } else {
                completion((.success, "Successfully added the question to db."))
            }
        }
    }
}
