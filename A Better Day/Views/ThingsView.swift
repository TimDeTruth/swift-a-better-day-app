//
//  ThingsView.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import SwiftUI
import SwiftData

struct ThingsView: View {
    
    ///look for today, its a day array cause cant assume always corrrect one per day
    ///retrieve Thing for one specific Day
    ///Calendar.autoupdatingCurrent, adjusts to different calendars types. travel to another country
    ///starofDay -
    ///end 24 hour period
    ///compare the time of the day, where its > start but < end
    @Query(filter:Day.currentDayPredicate(), sort: \.date) private var today:[Day]
    
    /// query to retrieve from database via swiftdata
    /// () to filter the query where isHidden is false
    /// $0 current thing, if isHidden == false, then retrieve it
    @Query(filter: #Predicate<Thing>{$0.IsHidden == false}) private var things: [Thing]
    
    @Environment(\.modelContext) private var context
    
    @State private var showAddView: Bool = false
    
    var body: some View {
        VStack (spacing: 20){
            
            Text("Things")
                .bold()
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("These are the things that make you feel postivve and uplifted.")
                .frame(maxWidth: .infinity, alignment: .leading)

            
            if things.count == 0 {
                // Display the image
                Image("things")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300)
                
                //ToolTip View
                ToolTipView(text: "Start by adding things that brighten your day. Tap the button below to get started!")
            }else {
                List (things){ thing in
                    let today = getToday()
                    HStack {
                        Text(thing.title)
                        Spacer()
                        Button(action: {
                            
                            if today.things.contains(thing){
                                /// remove from db if tapped again
                                /// remove where t == thing, remove all intances from today list of Things where it equals the list row i clicked on
                                today.things.removeAll(where: {t in
                                    t == thing
                                })
                                try? context.save()
                            }
                            else{
                                // TODO: add thing to today
                                today.things.append(thing)/// retrieving todays Day object, and in that Day you have an array of things, and then im appeneidng to that array object
                            }
                            
                            
                            
                        }, label: {
                            
                            //if thing is already in Today's things array, show a solid checkmark instead
                            if today.things.contains(thing){
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.blue)
                                
                            }
                            else{
                                Image(systemName: "checkmark.circle")
                                
                            }
                        })
                    }
                }
                .listStyle(.plain)//removes the default gray background list style
            }
                
            
            
            Spacer()
            
            Button("Add New Thing") {
                // TODO: show sheet to add thing -> toggle showAddView
                showAddView.toggle()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity,
                   alignment: .center)//take up the whole width and center it
            
            Spacer()
        }
        .sheet(isPresented: $showAddView, content: {
            AddThingView()
                .presentationDetents([.fraction(0.2)])//make it not fullscreen, can specify how high it goes full, half, quarter, can specify multiple positions. eg starts of 25% and user drags up to half
        })
    }
    
    ///try to retrieve current Day from db.
    ///if it does not exist create a day and insert
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
    ThingsView()
}
