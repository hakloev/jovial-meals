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
    
    func getUpcomingMonday() -> Date {
        let today = Date()
        let calendar = Calendar.current
        let todayWeekday = calendar.component(.weekday, from: today)
        
        var untilMonday =  (7 + 2 - todayWeekday) % 7 // 2: monday number
        untilMonday = untilMonday == 0 ? 7 : untilMonday
    
        let nextMonday = today.addingTimeInterval(TimeInterval(60 * 60 * 24 * Double(untilMonday)))
        return nextMonday
    }

    
}
