//
//  RemindersView.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import SwiftUI
import SwiftData
import UserNotifications

struct RemindersView: View {
    
    //    @State private var isRemindersOn = false
    @AppStorage("RemindersOn") private var isRemindersOn = false
    /// select time sometime in the future, 1 day later as default
    /// save the selected reminder date and time accross app sessions
    /// when the user has set a time that they want to be reminded on,
    /// when they relaunch the app you dont want that to change
    @State private var selectedDate = Date().addingTimeInterval(86400)
    
    @State private var isSettingsDialogShowing = false
    
    /// saving the time of day across app launches, so its the same every time you launch
    /// dont need SwiftData for something simple values
    /// cant save Date in appstorage but can convert a date to numbber of seocnds
    /// retrieve it and turn the number of seconds back into a date
    @AppStorage("ReminderTime") private var reminderTime: Double = Date().timeIntervalSince1970
    
    //computer property -> calculated when accessed
    var formattedTime: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Reminders")
                .bold()
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Remind yourself to do something uplifiting everyday.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Toggle(isOn: $isRemindersOn, label: {
                Text("Toggle Reminders")
            })
            
            ///check if the app has permission to send noti to user
            if isRemindersOn{
                HStack{
                    Text("What time?")
                    Spacer()
                    ///selection is binding to specific date, selective date, act on when date is changed, whcih date is set
                    ///check on change of the selected time cause when the user changes the reminder time
                    ///we need to unschedule currently scheudled reminded and rescheulde them for the new time
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                }
                
                // ToolTip saying when reminders are set for
                
                VStack(alignment: .leading, spacing:20){
                    Text(Image(systemName: "bell.and.waves.left.and.right"))
                    Text("You'll recieve a friendly reminder at \(formattedTime) on selected days to make your day better!")
                }
                .foregroundStyle(Color.blue)
                .padding()
                .background(){
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.blue, lineWidth: 1)
                        .background(Color("light-blue"))
                        
                    }
            }
            else{
                // ToolTip to turn reminders on
                ToolTipView(text: "Turn on reminders above to remind yourself to make each day better!")
                
            }
            
            Spacer()
            Image("reminders")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
            
            Spacer()
        }
        .onAppear(perform: {
            //TODO: convert back selectedDate
            selectedDate = Date(timeIntervalSince1970: reminderTime)
        })
        .onChange(of: isRemindersOn, {oldValue,newValue in
            //TODO: chekc for permissions to send notifictions
            /// when the reminders toggle is on, we check permissions
            
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            /// call this method to see what we have access to
            notificationCenter.getNotificationSettings(completionHandler: {setting in
                switch setting.authorizationStatus{
                case .authorized:
                    print("Notifiations are authorized.")
                    ///dont do anything cause we already have auth
                    //TODO: schedule the notifcaitions
                    scheduleNotifications()
                    
                case .denied:
                    print("Notification are denied.")
                    
                    /// if the user denies permission, toggle off reminders off cause we cant want toshow the date picker if permission is denied
                    isRemindersOn = false
                    // TODO:show a dialog that we cant send not cause they previously denied,call goToSettings() have a button to send user to settings so they can enable
                    isSettingsDialogShowing = true
                case .notDetermined:
                    print("Notification permission has not been asked yet.")
                    /// this is the allow/deny dialog
                    //TODO: request notifcation permission
                    requestNotificationPermission()
                default:
                    break
                }})
            
            
        })
        .onChange(of: selectedDate, { oldValue, newValue in
            // we want to schduleNotification() here too, but not before i unscheudle all the currently scheudle remindeds
            //TODO: unschedule all currenlty scheudled reminders
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllPendingNotificationRequests()
            
            //TODO: schedule new reminders, according to new ones
            scheduleNotifications()
            // Save new time
            reminderTime = selectedDate.timeIntervalSince1970
            
        })
        .alert(isPresented: $isSettingsDialogShowing) {
            
            Alert(title: Text("Notifications Disabled"),
                  message: Text("Reminders won't be sent unless Notifications are allowed. Please allow them in Settings."),primaryButton: .default(Text("Go to Settings"),action: {
                // TODO: Go to settings
                goToSettings()
            }), secondaryButton: .cancel())
        }
        
        .padding()
    }
    
    func goToSettings() {
        
        //opens settings specifically for the app
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            
            if UIApplication.shared.canOpenURL(appSettings) {
                
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func requestNotificationPermission(){
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .badge,.sound]) { granted, error in
            
            if granted {
                print("Permission granted")
                //TODO: if permission is granted, call scheduleNotifications()
                scheduleNotifications()
            } else{
                print("Permission denied")
                
                /// if the user denies permission, toggle off reminders off cause we cant want toshow the date picker if permission is denied
                isRemindersOn = false
                
                // TODO:show a dialog that we cant send not cause they previously denied,call goToSettings() have a button to send user to settings so they can enable. this is all listening to $isSettngsDialogShowing state
                isSettingsDialogShowing = true
                
                
                
                
            }
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    
    func scheduleNotifications() {
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Create the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "A Better Day"
        content.body = "Don't forget to do something for yourself today!"
        content.sound = .default
        
        // Define the time components for the notification (8:00 AM in this case)
        /// we are using our selectedTime we entered, getting the hour and minute from our selectedDate
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.autoupdatingCurrent.component(.hour, from: selectedDate)
        dateComponents.minute = Calendar.autoupdatingCurrent.component(.minute, from: selectedDate)
        
        // Create a trigger that repeats every day at the specified time
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the notification request with a unique identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Schedule the notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled.")
            }
        }
    }
    
    
    
    
    
}

#Preview {
    RemindersView()
}
