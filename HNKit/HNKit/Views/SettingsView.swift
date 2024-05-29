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
    
    init() {
            // Entire List Background
        UITableView.appearance().backgroundColor = .red
    }
    
    var body: some View {
        ZStack {
            Color(viewModel.selectedTheme.B)
                .ignoresSafeArea()
            
            VStack {
                List {
                    
                    Section {
                        Button(action: {
                            themeSelectorPresented = true
                        }, label: {
                            Text("Theme")
                                .foregroundStyle(Color(viewModel.selectedTheme.F))
                        })
                        
                    } header: {
                        Text("Appearance")
                    } footer: {
                        Text("Additional settings will be added in future updates.")
                            .padding()
                    }
                    
                    
                    
                }
                .sheet(isPresented: $themeSelectorPresented, content: {
                    ThemeSelector()
                        .environmentObject(viewModel)
                })
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Settings")
            }
        }
        
        
    }
}

#Preview {
    SettingsView()
        .environmentObject(HackerNewsViewModel())
}
