//
//  RecipeListResponse.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 12/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import ObjectMapper

struct RecipeListResponse: Mappable {
    
    var count: Int?
    var results: [Recipe]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        count <- map["count"]
        results <- map["results"]
    }
}
