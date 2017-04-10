//
//  Plan.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 10/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import SwiftyJSON

struct Plan {
    var id: Int?
    let startDate: String
    let endDate: String
    var meals: [Meal]?
    
    init(json: JSON) {
        id = json["id"].int
        startDate = json["start_date"].string!
        endDate = json["end_date"].string!
        meals = []
        
        if json["meals"].exists() {
            for meal in json["meals"].array! {
                let tempMeal = Meal(json: meal)
                meals!.append(tempMeal)
            }
        }
        
    }
}
