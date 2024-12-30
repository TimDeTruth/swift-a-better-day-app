//
//  TodayView.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import SwiftUI
import SwiftData
///list of things i have done today
struct TodayView: View {
    
    /// passed from HomeView
    @Binding var selectedTab: Tab
    
    
    
    /// context to access the data layer for SwiftData
    @Environment(\.modelContext) private var context
    
    ///look for today, its a day array cause cant assume always corrrect one per day
    ///retrieve Thing for one specific Day
    ///Calendar.autoupdatingCurrent, adjusts to different calendars types. travel to another country
    ///starofDay -
    ///end 24 hour period
    ///compare the time of the day, where its > start but < end
    @Query(filter:Day.currentDayPredicate(), sort: \.date) private var today:[Day]
    
    
    var body: some View {
        
        VStack(spacing: 20){
            Text("Today")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Try to do things that make you feel postive today!")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ///only display the list if there are things done today
            ///if it > 0 show the list else nothing
            if getToday().things.count > 0 {
                List(getToday().things){ thing in
                    
                    Text(thing.title)
                    
                }
                .listStyle(.plain)
            }else{
                // TODO: display the image and some tool tips
                Spacer()
                Image("today")
                    .resizable()
                    .aspectRatio(contentMode: .fit)//makes sure no overflow edeges
                    .frame(maxWidth: 300)
                ToolTipView(text:"Take a lttle time out of your busy day and do something that recaharges you. Hit the log button below to start!")
                
                /// Access the @State from HomeView for the selected tab using binding
                Button {
                    // TODO: switch to Things tab
                    selectedTab = Tab.things
                } label: {
                    Text("Log")
                    
                }
                .buttonStyle(.borderedProminent)
                
                
                Spacer()
            }
            
            
        }
    }
    
    ///try to retrieve current Day from DB,
    ///if it does not exist create a new day and insert
    func getToday()-> Day{
        if today.count > 0 {
            return today.first! //return the first item of the array
        }
        else{
            ///if it does not exist create a day and insert
            let today = Day()
            /// need access to the context
            context.insert(today)
            try? context.save()
            
            return today
        }
    }
}

#Preview {
    TodayView(selectedTab: Binding.constant(Tab.things))
}
