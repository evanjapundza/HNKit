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
        
        ZStack {
            Color(viewModel.selectedTheme.B)
                .ignoresSafeArea()
            
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], content: {
                    ForEach(0..<ThemeManager.themes.count, id:\.self) { theme in
                        Button(action: {
                            viewModel.selectedThemeAS = theme
                            print("changing to theme \(theme)")
                        }, label: {
                            VStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 5)
                                    HStack(spacing: 0) {
                                        Group {
                                            Color(ThemeManager.themes[theme].A)
                                            Color(ThemeManager.themes[theme].B)
                                            Color(ThemeManager.themes[theme].F)
                                            Color(ThemeManager.themes[theme].G)
                                            Color(ThemeManager.themes[theme].H)
                                        }
                                    }
                                    .frame(minHeight: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                                Text(ThemeManager.themes[theme].themeName)
                                    .foregroundStyle(Color(viewModel.selectedTheme.A))
                                
                            }
                            .padding()
                        })
                        .background(ThemeManager.themes[theme].themeName == ThemeManager.themes[viewModel.selectedThemeAS].themeName ? Color(viewModel.selectedTheme.L) : .gray)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                })
                .padding()
                
                Text("More themes will be added in the future!")
                    .foregroundStyle(.gray)
                    .padding()
                
                Spacer()
            }
        }
        
        
    }
}

#Preview {
    ThemeSelector()
        .environmentObject(HackerNewsViewModel())
}
