//
//  DateUtil.swift
//  Foodz
//
//  Created by Håkon Ødegård Løvdal on 07/04/2017.
//  Copyright © 2017 Håkon Ødegård Løvdal. All rights reserved.
//

import Foundation

extension Date {
    
    func getWeekNumber() -> Int {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.weekOfYear], from: self)
        return dateComponents.weekOfYear!
    }
}
