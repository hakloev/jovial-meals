//
//  Meal.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 10/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import ObjectMapper

struct Meal: Mappable {
    var id: Int?
    var day: Int?
    var eaten: Bool?
    var recipeId: Int?
    
//    init(json: JSON) {
//        id = json["id"].int
//        day = json["day"].int!
//        eaten = json["eaten"].bool!
//        if json["recipe"] != JSON.null {
//            //recipe = Recipe(json: json["recipe"])
//        } else {
//            recipe = nil
//        }
//    }
    
    init?(map: Map) {}
    
    init(day: Int) {
        id = nil
        self.day = day
        eaten = false
        recipeId = nil
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        day <- map["day"]
        eaten <- map["eaten"]
        recipeId <- map["recipe_id"]
    }
}
