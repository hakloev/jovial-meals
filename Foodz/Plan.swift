//
//  Plan.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 10/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import ObjectMapper

struct Plan: Mappable {
    var id: Int?
    var startDate: String?
    var endDate: String?
    var meals: [Meal]?
    
//    init(json: JSON) {
//        id = json["id"].int
//        startDate = json["start_date"].string!
//        endDate = json["end_date"].string!
//        meals = []
//        
//        if json["meals"].exists() {
//            for meal in json["meals"].array! {
//                let tempMeal = Meal(json: meal)
//                meals!.append(tempMeal)
//            }
//        }
//        
//    }
    
    init?(map: Map) {}
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        startDate = dateFormatter.string(from: Date().getUpcomingMonday())
        endDate = ""
        meals = []
        
        for i in 0..<7 {
            meals!.append(Meal(day: i))
        }
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        startDate <- map["start_date"]
        endDate <- map["end_date"]
        meals <- map["meals"]
    }
    
}
