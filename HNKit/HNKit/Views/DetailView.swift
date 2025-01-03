//
//  DetailView.swift
//  HNKit
//
//  Created by Evan Japundza on 3/31/24.
//

import SwiftUI
import WebKit
import FirebaseAnalytics

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
        ZStack {
            Color(viewModel.selectedTheme.B)
                .ignoresSafeArea()
            
            switch itemType {
            case .story:
                storyView
                
            case .job:
                jobView
            }
        }
        .onAppear {
            // Log view event with item details
            var parameters: [String: Any] = [
                AnalyticsParameterScreenName: "Detail",
                AnalyticsParameterScreenClass: "DetailView",
                "item_type": itemType == .story ? "story" : "job"
            ]
            
            if let story = story {
                parameters["story_id"] = story.id
                parameters["story_title"] = story.title
            } else if let job = job {
                parameters["job_id"] = job.id
                parameters["job_title"] = job.title
            }
            
            Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
        }
    }
    
    var storyView: some View {
        VStack {
            if let story = story {
                VStack {
                    if let itemURL = story.url {
                        WebView(url: URL(string: itemURL)!)
                            .edgesIgnoringSafeArea(.bottom)
                    } else {
                        if let itemText = story.text {
                            ScrollView {
                                Text(story.title)
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(Color(viewModel.selectedTheme.H))
                                
                                HStack {
                                    Text(story.by)
                                    Spacer()
                                    Text(story.relativeTimeString)
                                    Spacer()
                                    Text("\(story.score)")
                                }
                                .padding(5)
                                .foregroundStyle(Color(viewModel.selectedTheme.G))
                                
                                Divider()
                                
                                Text(itemText.html2String)
                                    .padding()
                                    .font(.title)
                            }
                            .padding()
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
                                .foregroundStyle(Color(viewModel.selectedTheme.F))
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
        VStack {
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
//
//#Preview {
//    DetailView(story: Story(
//        id: 00001,
//        title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
//        url: nil,
//        score: 449,
//        time: 10.0,
//        by: "alt-glitch",
//        descendants: 49,
//        type: "story",
//    }
