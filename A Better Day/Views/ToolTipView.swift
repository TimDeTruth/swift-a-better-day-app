//
//  ToolTipView.swift
//  A Better Day
//
//  Created by Timmy Lau on 2024-12-21.
//

import SwiftUI

struct ToolTipView: View {
    var text:String
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color.blue)
            .padding()
            .background(){
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.blue, lineWidth: 1)
                    .background(Color("light-blue"))
            }
    }
}

#Preview {
    ToolTipView(text: "Bogus")
}
