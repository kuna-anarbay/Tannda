//
//  Shop.swift
//  Qolzhetimdi
//
//  Created by Kuanysh Anarbay on 5/9/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Shop {
    
    var id: String = ""
    var name: String = ""
    var about: String = ""
    var branchId: String = ""
    var logo: String = ""
    var background: String = ""
    var itemsCount: Int = 0
    var date: Date = Date()
    var rating: Rating = Rating()
    var contacts: [Contact] = [Contact]()
    var socialMedia: [Contact] = [Contact]()
    var workingHours: [Day] = [Day]()
    var branches: [Branch] = [Branch]()
    var getRating: Float {
        get {
            let count: Float = Float(self.rating.five + self.rating.four + self.rating.three + self.rating.two + self.rating.one)
            let sum: Float = Float(self.rating.five*5) + Float(self.rating.four*4) + Float(self.rating.three*3) + Float(self.rating.two*2) + Float(self.rating.one)
            
            return count == 0 ? 0 : sum/count
        }
    }
    var todayOpen: String {
        get {
            let today = lists.days[Calendar.current.component(.weekday, from: Date()) - 1]
            
            if let day = workingHours.first(where: {$0.day == today}) {
                return Timestamp.display24HourTimeGMT0(timestamp: day.start) + " - " + Timestamp.display24HourTimeGMT0(timestamp: day.end)
            }
            
            return "Closed"
        }
    }
    var openStatus: String {
        get {
            let today = lists.days[Calendar.current.component(.weekday, from: Date())]
            let currentTime = Timestamp.displayHourMinuteTimestamp(timestamp: Int(Date().timeIntervalSince1970))
            
            if let day = workingHours.first(where: {$0.day == today}) {
                if day.start < currentTime {
                    return "Opens at " + Timestamp.display24HourTimeGMT0(timestamp: day.start*1000)
                } else if day.end > currentTime {
                    return "Open"
                } else {
                    return "Closed"
                }
            }
            
            return "Closed"
        }
    }
    var openColor: UIColor {
        get {
            let today = lists.days[Calendar.current.component(.weekday, from: Date())]
            let currentTime = Timestamp.displayHourMinuteTimestamp(timestamp: Int(Date().timeIntervalSince1970))
            
            if let day = workingHours.first(where: {$0.day == today}) {
                if day.start < currentTime {
                    return UIColor.systemOrange
                } else if day.end > currentTime {
                    return UIColor.systemGreen
                } else {
                    return UIColor.systemRed
                }
            }
            return UIColor.systemRed
        }
    }
    
    
    init(){
        
    }
    
    
    init(_ document: QueryDocumentSnapshot){
        self.id = document.documentID
        let data = document.data()
        
        self.name = data["title"] as! String
        self.logo = data["logo"] as! String
        self.background = data["background"] as? String ?? ""
        self.itemsCount = data["items_count"] as? Int ?? 0
        
        
        if let hours = data["working_hours"] as? [String: [String: Int]] {
            for day in hours {
                workingHours.append(Day(day.key, day.value))
            }
        }
        if let rating = data["rating"] as? [String: Int] {
            self.rating.five = rating["five"] ?? 0
            self.rating.four = rating["four"] ?? 0
            self.rating.three = rating["three"] ?? 0
            self.rating.two = rating["two"] ?? 0
            self.rating.one = rating["one"] ?? 0
        }
    }
    
    init(_ document: DocumentSnapshot){
        self.id = document.documentID
        if let data = document.data() {
            self.name = data["title"] as! String
            self.about = data["about"] as! String
            self.logo = data["logo"] as! String
            self.background = data["background"] as? String ?? ""
            self.itemsCount = data["items_count"] as? Int ?? 0
            
            
            if let hours = data["working_hours"] as? [String: [String: Int]] {
                for day in hours {
                    workingHours.append(Day(day.key, day.value))
                }
            }
            
            if let rating = data["rating"] as? [String: Int] {
                self.rating.five = rating["five"] ?? 0
                self.rating.four = rating["four"] ?? 0
                self.rating.three = rating["three"] ?? 0
                self.rating.two = rating["two"] ?? 0
                self.rating.one = rating["one"] ?? 0
            }
        }
    }
    
    static func getAll(completion: @escaping([Shop]) -> Void){
        Constants.shopsRef.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                var shops = [Shop]()
                for document in snapshot.documents {
                    shops.append(Shop(document))
                }
                completion(shops)
            } else {
                completion([])
            }
        }
    }
    
    func getThis(completion: @escaping(Shop) -> Void){
        Constants.shopsRef.document(self.id).getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                completion(Shop(snapshot))
            } else {
                completion(self)
            }
        }
    }
}


class Rating {
    var one: Int = 0
    var two: Int = 0
    var three: Int = 0
    var four: Int = 0
    var five: Int = 0
    var count: Int {
        get {
            return self.five + self.four + self.three + self.two + self.one
        }
    }
    var getAll: [(Int, Float)] {
        get {
            var res = [(Int, Float)]()
            let temp = count==0 ? 1 : count
            res.append((one, Float(one*100/temp)))
            res.append((two, Float(two*100/temp)))
            res.append((three, Float(three*100/temp)))
            res.append((four, Float(four*100/temp)))
            res.append((five, Float(five*100/temp)))
            
            return res
        }
    }
}

class Contact {
    var data: String = ""
    var type: String = ""
}

class Day {
    var day: String = ""
    var start: Int = 0
    var end: Int = 0
    
    init(){
        
    }
    
    init(_ day: String, _ value: [String: Int]){
        self.day = day
        self.start = value["start"]!
        self.end = value["end"]!
    }
}

class Branch {
    var adress: String = ""
    var latitude: String = ""
    var longitude: String = ""
}
