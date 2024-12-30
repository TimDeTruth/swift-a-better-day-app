//
//  Thing.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import Foundation
import SwiftData

@Model
class Thing: Identifiable{
    var id: String = UUID().uuidString
    var title: String = ""
    var lastUpdated: Date = Date()
    var IsHidden: Bool = false
    
    
    init(title: String) {
        self.title = title
    }
}
