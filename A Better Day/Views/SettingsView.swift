//
//  SettingsView.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-20.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 20) {
            
            Text("Settings")
                .font(.largeTitle)
                .bold()
            
            List {
                
                // Rate the app, put your app store URL, replace number
                let reviewUrl = URL(string: "https://apps.apple.com/app/id6670766958?action=write-review")!
                
                //opens URL, safari -> redirect to app store
                Link(destination: reviewUrl, label: {
                    HStack {
                        Image(systemName: "star.bubble")
                        Text("Rate the app")
                    }
                })
                
                
                // Recommend the app, share link, open share sheet,
                let shareUrl = URL(string: "https://apps.apple.com/app/id6670766958")!
                ShareLink(item: shareUrl) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("Recommend the app")
                    }

                }
                
                // Contact
                Button  {
                    // Compose email
                    let mailUrl = createMailUrl()
                    
                    if let mailUrl = mailUrl, UIApplication.shared.canOpenURL(mailUrl) {
                        UIApplication.shared.open(mailUrl)//open default mail app on device
                    }
                    else {
                        print("Couldn't open mail client")
                    }
                    
                } label: {
                    HStack {
                        Image(systemName: "quote.bubble")
                        Text("Submit feedback")
                    }
                    
                }
                
                
                // Privacy Policy, use privary policy generator,
                // easiest is to host on Notion -> free
                let privacyUrl = URL(string: "https://codewithchris.com/abd-privacy-policy/")!
                
                Link(destination: privacyUrl, label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Privacy Policy")
                    }
                })
                
                
            }
            .listRowSeparator(.hidden)
            .listStyle(.plain)
            .tint(.black)
        }
    }
    
    func createMailUrl() -> URL? {
        
        var mailUrlComponents = URLComponents()
        mailUrlComponents.scheme = "mailto"
        mailUrlComponents.path = "care@codewithchris.com"
        mailUrlComponents.queryItems = [
            URLQueryItem(name: "subject", value: "Feedback for A Better Day app")
        ]
        
        return mailUrlComponents.url
    }
    
}

#Preview {
    SettingsView()
}


 
