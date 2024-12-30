//
//  AddThingView.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-21.
//

import SwiftUI
import SwiftData

struct AddThingView: View {
    
    
    /// Dismiss the sheet, done by accessing an Enviornment variable
    @Environment(\.dismiss) private var dismiss
    
    /// access the context which accesses the database layer, retrieve and add, need the model context
    /// create a thing, a new instance of a Thing, insert into the context -> adds into database
    @Environment(\.modelContext) private var context
    @State private var thingTitle = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("What makes you feel good?", text: $thingTitle)
                .textFieldStyle(.roundedBorder)
            Button("Add"){
                // TODO: add into swiftdata, call add thing
                addThing()
                
                thingTitle = ""// reset the text
                
                dismiss()//close the sheet
            }
            .buttonStyle(.borderedProminent)
            .disabled(thingTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? true : false)//disable the button if the text entered is whitespace 
            
        }
        .padding()
    }
    
    
    func addThing(){
        // TODO: clean text, remove white space and \n new line
        let cleanedTitle = thingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // TODO: add into db
        context.insert(Thing(title: cleanedTitle))
        try? context.save()
        
    }
}

#Preview {
    AddThingView()
}
