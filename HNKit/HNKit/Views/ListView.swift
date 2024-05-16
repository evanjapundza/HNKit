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
            ZStack {
                Color(red: 0.925, green: 0.937, blue: 1) // #ecefff
                    .ignoresSafeArea()
                
                switch listType {
                case .story:
                    storyList
                case .job:
                    jobList
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
        
    }
    
    var storyList: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                VStack {
                    HStack {
                        Text("TOP STORIES")
                            .font(.system(size: 28, design: .monospaced))
                            .foregroundStyle(Color(red: 0.341, green: 0.235, blue: 0.98))
                        
                        Spacer()
                        
                    }
                    
                    Rectangle()
                        .foregroundStyle(Color(red: 0.341, green: 0.235, blue: 0.98))
                        .frame(maxWidth: .infinity, maxHeight: 1)
                }
                .padding(.horizontal)
                
                LazyVStack {
                    ForEach(viewModel.topStories) { story in
                        NavigationLink {
                            DetailView(story: story, itemType: ItemType.story)
                                .environmentObject(viewModel)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(story.title)
                                    .multilineTextAlignment(.leading)
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
                        }
                        .frame(minHeight: 15)
                        .padding()
                        
                        Divider()
                        
                    }
                }
            }
            
            Spacer()
        }
    }
    
    var jobList: some View {
        VStack(alignment: .leading) {
            

            
            ScrollView {
                VStack {
                    HStack {
                        Text("TOP JOBS")
                            .font(.system(size: 28, design: .monospaced))
                            .foregroundStyle(Color(red: 0.341, green: 0.235, blue: 0.98))
                        
                        Spacer()
                        
                    }
                    
                    Rectangle()
                        .foregroundStyle(Color(red: 0.341, green: 0.235, blue: 0.98))
                        .frame(maxWidth: .infinity, maxHeight: 1)
                }
                .padding(.horizontal)
                
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.topJobs) { job in
                        NavigationLink {
                            DetailView(job: job, itemType: ItemType.job)
                                .environmentObject(viewModel)
                        } label: {
                            Text(job.title)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 14, design: .monospaced))
                        }
                        .frame(minHeight: 30)
                        .padding()

                        
                        Divider()
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ListView(listType: .story)
        .environmentObject(HackerNewsViewModel())
}
