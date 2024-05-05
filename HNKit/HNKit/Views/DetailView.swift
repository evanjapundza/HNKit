//
//  DetailView.swift
//  HNKit
//
//  Created by Evan Japundza on 3/31/24.
//

import SwiftUI
import WebKit

struct DetailView: View {
    
    @EnvironmentObject var viewModel: HackerNewsViewModel
    
    var itemURL: String?
    var itemText: String?
    var itemKids: [Int]?
    var itemID: Int?
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let itemURL = itemURL {
                    WebView(url: URL(string: itemURL)!)
                        .edgesIgnoringSafeArea(.bottom)
                } else {
                    if let itemText = itemText {
                        Text(itemText.html2String)
                            .padding()
                            .font(.title)
                    }
                }
                
                
            }
            .scrollDisabled(true)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isPresented = true
                    }, label: {
                        Image(systemName: "text.bubble")
                    })
                }
            }
            .sheet(isPresented: $isPresented, content: {
                if let itemID = itemID {
                    CommentsView(storyID: itemID)
                        .environmentObject(viewModel)
                }
            })
        }
        .tint(.blue)
    }
}

#Preview {
    DetailView(itemURL: "www.google.com")
}
