//
//  Recipe.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 10/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import SwiftyJSON

struct Recipe {
    var id: Int?
    var name: String
    var website: String?
    let recipeType: String
    
    init(json: JSON) {
        id = json["id"].int
        name = json["name"].string!
        website = json["website"].string
        recipeType = json["recipe_type"].string!
    }
    
    init(name: String, website: String = "", recipeType: String = "F") {
        self.name = name
        self.website = website
        self.recipeType = recipeType
    }
    
    func toParameters() -> [String:String] {
        return [
            "name": name,
            "website": website ?? "",
            "recipe_type": recipeType
        ]
    }
}
