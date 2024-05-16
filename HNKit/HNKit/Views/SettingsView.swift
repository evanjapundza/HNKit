//
//  SettingsView.swift
//  HNKit
//
//  Created by Evan Japundza on 3/25/24.
//

import SwiftUI

struct SettingsView: View {
    // FUTURE UPDATE STUFF
    
    @State var themeSelectorPresented = false
    @EnvironmentObject var viewModel: HackerNewsViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Text("Upgrade to Premium")
                
                Section(header: Text("APPEARANCE")) {
                    Button(action: {
                        themeSelectorPresented = true
                    }, label: {
                        Text("Theme")
                    })
                    
                }
                
                Section {
                    Text("About")
                    Text("Rate")
                    Text("Share")
                }
            }
            .sheet(isPresented: $themeSelectorPresented, content: {
                ThemeSelector()
                    .environmentObject(viewModel)
            })
            .navigationBarTitleDisplayMode(.large)
            .navigationTitle("Settings")
            
        }
        
    }
}

#Preview {
    SettingsView()
}
