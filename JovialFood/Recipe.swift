//
//  Recipe.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 10/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import ObjectMapper

struct Recipe: Mappable {
    var id: Int?
    var name: String?
    var website: String?
    var recipeType: String?
    
//    init(json: SwiftyJSON.JSON) {
//        id = json["id"].int
//        name = json["name"].string
//        website = json["website"].string
//        recipeType = json["recipe_type"].string
//    }
    
    init?(map: Map) {}
    
    init(name: String, website: String = "", recipeType: String = "F") {
        self.name = name
        self.website = website
        self.recipeType = recipeType
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        website <- map["website"]
        recipeType <- map["recipe_type"]
    }
    
    
}
