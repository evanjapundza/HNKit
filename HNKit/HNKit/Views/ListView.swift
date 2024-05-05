//
//  ListView.swift
//  HNKit
//
//  Created by Evan Japundza on 4/2/24.
//

import SwiftUI

enum ListType {
    case story
    case job
}


struct ListView: View {
    @EnvironmentObject var viewModel: HackerNewsViewModel
    
    let listType: ListType
    
    var body: some View {
        NavigationStack {
            switch listType {
            case .story:
                storyList
            case .job:
                jobList
            }
        }
        .tint(.blue)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
        
    }
    
    var storyList: some View {
        VStack(alignment: .leading) {
            
            
            List {
                VStack {
                    HStack {
                        Text("TOP STORIES")
                            .font(.system(size: 28, design: .monospaced))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                    }
                    
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.none)
                
                ForEach(viewModel.topStories) { story in
                    
                    NavigationLink {
                        if let storyURL = story.url {
                            DetailView(itemURL: storyURL, itemKids: story.kids, itemID: story.id)
                                .environmentObject(viewModel)
                        } else {
                            if let storyText = story.text {
                                DetailView(itemText: storyText, itemKids: story.kids, itemID: story.id)
                                    .environmentObject(viewModel)
                            }
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(story.title)
                                .font(.system(size: 14, design: .monospaced))
                            
                            HStack {
                                Text("\(story.descendants) comments")
                                Image(systemName: "arrow.up")
                                Text("\(story.score)")
                                Spacer()
                                Text(story.by)
                                Text("•")
                                Text("\(story.relativeTimeString)")
                            }
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.secondary)
                        }
                        .frame(height: 75)
                        .listRowSeparatorTint(.gray)
                        .listRowSeparator(.automatic, edges: .all)
                    }
                    
                }
                .listSectionSpacing(0)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .bottom)
            .scrollContentBackground(.hidden)
            
            Spacer()
        }
        .padding()
    }
    
    var jobList: some View {
        VStack(alignment: .leading) {
            
            List {
                VStack {
                    HStack {
                        Text("TOP JOBS")
                            .font(.system(size: 28, design: .monospaced))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                    }
                    
                    Rectangle()
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.none)
                
                ForEach(viewModel.topJobs) { job in
                    
                    NavigationLink {
                        if let jobURL = job.url {
                            DetailView(itemURL: jobURL)
                                .environmentObject(viewModel)
                        } else {
                            if let jobText = job.text {
                                DetailView(itemText: jobText)
                                    .environmentObject(viewModel)
                            }
                        }
                    } label: {
                        Text(job.title)
                            .frame(height: 75)
                            .listRowSeparatorTint(.gray)
                            .listRowSeparator(.automatic, edges: .all)
                    }
                    
                }
                .listSectionSpacing(0)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .bottom)
            .scrollContentBackground(.hidden)
        }
        .padding()
    }
}

#Preview {
    ListView(listType: .story)
        .environmentObject(HackerNewsViewModel())
}
