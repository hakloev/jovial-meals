//
//  PlanDetailResponse.swift
//  JovialFood
//
//  Created by Håkon Ødegård Løvdal on 13/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//


import ObjectMapper

struct PlanDetailResponse: Mappable {
    
    var plan: Plan?
    var recipes: [Recipe]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        plan <- map["plan"]
        recipes <- map["recipes"]
    }
}
