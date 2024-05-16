//
//  DetailView.swift
//  HNKit
//
//  Created by Evan Japundza on 3/31/24.
//

import SwiftUI
import WebKit

enum ItemType {
    case story, job
}

struct DetailView: View {
    
    @EnvironmentObject var viewModel: HackerNewsViewModel
    
    @State var story: Story?
    var job: Job?
    var itemType: ItemType
    
    
    @State var isPresented: Bool = false
    
    var body: some View {
        switch itemType {
        case .story:
            storyView
                
        case .job:
            jobView
        }
        
    }
    
    var storyView: some View {
        NavigationStack {
            if let story = story {
                VStack {
                    if let itemURL = story.url {
                        WebView(url: URL(string: itemURL)!)
                            .edgesIgnoringSafeArea(.bottom)
                    } else {
                        if let itemText = story.text {
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
                    CommentsView(storyID: story.id)
                        .environmentObject(viewModel)
                })
            }
        }
        
    }
    
    var jobView: some View {
        NavigationStack {
            if let job = job {
                VStack {
                    if let itemURL = job.url {
                        WebView(url: URL(string: itemURL)!)
                            .edgesIgnoringSafeArea(.bottom)
                    } else {
                        if let itemText = job.text {
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
                    CommentsView(storyID: job.id)
                        .environmentObject(viewModel)
                })
            }
        }
    }
}

#Preview {
    DetailView(story: Story(
        id: 00002,
        title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
        url: "www.google.com",
        score: 449,
        time: 10.0,
        by: "alt-glitch",
        descendants: 49,
        type: "story"
    ), itemType: ItemType.story)
}
