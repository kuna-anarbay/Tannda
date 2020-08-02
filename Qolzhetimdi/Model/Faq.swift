//
//  Faq.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class FAQ {
    
    var id: String = ""
    var topic: String = ""
    var priority: Int = 0
    var question: String = ""
    var answer: String = ""

    init () {
    }
    
    init(_ document: QueryDocumentSnapshot) {
        self.id = document.documentID
        let data = document.data()
        self.topic = data["topic"] as! String
        self.priority = data["priority"] as! Int
        self.question = data["question"] as! String
        self.answer = data["answer"] as! String
    }
    
    static func getAll(completion: @escaping([FAQ]) -> Void) {
        Constants.faqsRef.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                var faqs = [FAQ]()
                for document in snapshot.documents {
                    faqs.append(FAQ(document))
                }
                completion(faqs)
            } else {
                completion([])
            }
        }
    }
}
