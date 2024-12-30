//
//  ContentView.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import SwiftUI
import SwiftData


enum Tab:Int{
    case today = 0
    case things = 1
    case reminders = 2
    case settings = 3
}

struct HomeView: View {
    
    ///selected state for the selected tab,
    ///if you want to programmatcally change tabs, you change the state property
    ///use enum over Int
    @State var selectedTab: Tab = Tab.today
    
    
    
    var body: some View {
        ///bind selectedTab to TabView
        TabView (selection: $selectedTab) {

            TodayView(selectedTab: $selectedTab)
                .tabItem({
                    Text("Today")
                    Image(systemName: "calendar")
                })
                .tag(Tab.today)
                

            ThingsView()
                .tabItem({
                    Text("Things")
                    Image(systemName: "heart")
                })
                .tag(Tab.things)
            RemindersView()
                .tabItem({
                    Text("Reminders")
                    Image(systemName: "bell")
                })
                .tag(Tab.reminders)
            SettingsView()
                .tabItem({
                    Text("Settings")
                    Image(systemName: "gear")
                })
                .tag(Tab.settings)
            
            
        }.padding()//applies padding to all tab views including the content
    }
}




#Preview {
    HomeView()
}
