//
//  Meal.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 10/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import SwiftyJSON

struct Meal {
    var id: Int?
    let day: Int
    let eaten: Bool
    var recipe: Recipe?
    
    init(json: JSON) {
        id = json["id"].int
        day = json["day"].int!
        eaten = json["eaten"].bool!
        if json["recipe"] != JSON.null {
            recipe = Recipe(json: json["recipe"])
        } else {
            recipe = nil
        }
    }
}
