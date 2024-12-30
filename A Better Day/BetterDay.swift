//
//  A_Better_DayApp.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import SwiftUI
import SwiftData

@main
struct BetterDay: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(for: [Day.self, Thing.self])//Swift Data container, types of data access the containers for
        }
    }
}
