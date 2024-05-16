//
//  ThemeSelector.swift
//  HNKit
//
//  Created by Evan Japundza on 5/14/24.
//

import SwiftUI

struct ThemeSelector: View {
    @EnvironmentObject var viewModel: HackerNewsViewModel
    var body: some View {
        
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], content: {
                ForEach(0..<ThemeManager.themes.count, id:\.self) { theme in
                    Button(action: {
                        viewModel.selectedThemeAS = theme
                        print("changing to theme \(theme)")
                    }, label: {
                        VStack {
                            Text(ThemeManager.themes[theme].themeName)
                            
                            if (ThemeManager.themes[theme].themeName == ThemeManager.themes[viewModel.selectedThemeAS].themeName) {
                                Image(systemName: "checkmark.circle")
                            } else {
                                Image(systemName: "circle")
                            }
                        }
                    })
                }
            })
            .padding()
            
            Spacer()
        }
        
    }
}

#Preview {
    ThemeSelector()
        .environmentObject(HackerNewsViewModel())
}
