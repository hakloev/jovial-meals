//
//  LoginResponse.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 12/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import ObjectMapper

struct LoginResponse: Mappable {
    var token: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        token <- map["token"]
    }
}

