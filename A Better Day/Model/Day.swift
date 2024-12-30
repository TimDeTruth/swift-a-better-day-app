//
//  Day.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import Foundation
import SwiftData

@Model
class Day: Identifiable{
    var id: String = UUID().uuidString
    var date: Date = Date()
    var things = [Thing]()//for every day i have a array of things
    
    //empty initializer
    init() {
        
    }
    
}


/// create an extention for the class
/// add a static method
/// getting day objects from start of day to now
extension Day{
    static func currentDayPredicate()-> Predicate<Day>{
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: Date.now)//for current day
        
        return #Predicate<Day>{
            $0.date >= start
        }
    }
}
