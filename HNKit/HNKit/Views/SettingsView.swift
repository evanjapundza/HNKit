//
//  SettingsView.swift
//  HNKit
//
//  Created by Evan Japundza on 3/25/24.
//

import SwiftUI

struct SettingsView: View {
    // FUTURE UPDATE STUFF
    var body: some View {
        NavigationStack {
            List {
                Text("Upgrade to Premium")
                
                Section(header: Text("APPEARANCE")) {
                    Text("Theme")
                }
                
                Section {
                    Text("About")
                    Text("Rate")
                    Text("Share")
                }
            }
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Settings")
            
        }
        
    }
}

#Preview {
    SettingsView()
}
