//
//  ContentView.swift
//  HNKit
//
//  Created by Evan Japundza on 3/24/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HackerNewsViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    @State var sheetPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {

                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            TabView {
                                
                                topStoryView
                                
                                topJobView
                                
                            }
                            .frame(minHeight: 400)
                            .tabViewStyle(.page(indexDisplayMode: .always))
                            .onAppear {
                                UIPageControl.appearance().currentPageIndicatorTintColor = .gray
                                UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.4)
                            }
                            
                            topStoriesView
                            
                            topJobsView
                            
                            Spacer()
                        }
                    }
                    
                    //                .toolbar {
                    //                    ToolbarItem {
                    //                        Button(action: {
                    //                            sheetPresented = true
                    //                        }, label: {
                    //                            Image(systemName: "gearshape.fill")
                    //                                .foregroundStyle(.black)
                    //                        })
                    //                    }
                    //                }
                }
            }
            .navigationTitle("HN Home")
            .tint(.accentColor)
        }
        .sheet(isPresented: $sheetPresented, content: {
            SettingsView()
        })
        .onAppear {
            viewModel.fetchTopStories()
            viewModel.fetchTopJobs()
        }
    }
    
    var topStoryView: some View {
        VStack(alignment: .leading) {
            Text("TOP STORY")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.gray)
                .padding(.horizontal)
            
            NavigationLink {
                if let topstory = viewModel.topStories.first {
                    if let topstoryURL = topstory.url {
                        DetailView(itemURL: topstoryURL, itemKids: topstory.kids, itemID: topstory.id)
                            .environmentObject(viewModel)
                    }
                }
            } label: {
                
                VStack(alignment: .leading) {
                    
                    
                    if let topstory = viewModel.topStories.first {
                        
                        GeometryReader { reader in
                            VStack(spacing: 0) {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        Text(topstory.title)
                                            .multilineTextAlignment(.leading)
//                                            .font(.largeTitle)
                                            .font(.system(size: 48))
                                            .minimumScaleFactor(0.6)
//                                        Spacer()
                                    }
                                    
                                    Spacer()
                                    
                                    Text("🔗 " + (topstory.url ?? ""))
                                        .fontWeight(.ultraLight)
                                        .font(.system(size: 12, design: .monospaced))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.85)
                                }
                                .padding()
                                .frame(width: reader.size.width, height: reader.size.height * 0.75)
                                
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    LinearGradient(colors: [colorScheme == .dark ? .black : .white, Color(.sRGB, white: 0.85, opacity: 1)], startPoint: .top, endPoint: .bottom)
                                        .frame(height: 4)
                                        .opacity(0.8)
                                        .padding(.horizontal, -20)
                                        .padding(.top, -20)
                                    
                                    Text("\(topstory.by) • \(topstory.relativeTimeString)")
                                    
                                    HStack {
                                        Text("\(topstory.descendants) comments")
                                        
                                        Text("↑\(topstory.score)")
                                        
                                    }
                                }
                                .padding()
                                .frame(height: reader.size.height * 0.25)
                            }
                        }
                    }
                    Spacer()
                }
                .foregroundStyle(.black)
                .frame(height: 320)
                .background(colorScheme == .dark ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .gray, radius: 4, x: -1, y: 2)
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
    
    var topJobView: some View {
        
        VStack(alignment: .leading) {
            Text("TOP JOB")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.gray)
                .padding(.horizontal)
            
            NavigationLink {
                if let topJob = viewModel.topJobs.first {
                    if let topJobURL = topJob.url {
                        DetailView(itemURL: topJobURL)
                            .environmentObject(viewModel)
                    }
                }
            } label: {
                VStack(alignment: .leading) {
                    
                    
                    if let topstory = viewModel.topJobs.first {
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(topstory.title)
                                .multilineTextAlignment(.leading)
                                .font(.system(size: 48))
                                .minimumScaleFactor(0.85)
                            
                            
                            Text("🔗 " + (topstory.url ?? ""))
                                .fontWeight(.ultraLight)
                                .font(.system(size: 12, design: .monospaced))
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                            
                            

                        }
                        .padding()
                    }
                }
            }
            .foregroundStyle(.black)
            .frame(height: 320)
            .background(colorScheme == .dark ? .black : .white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .gray, radius: 4, x: -1, y: 2)
            .padding(.horizontal)

            Spacer()
        }
    }
    
    var topStoriesView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("TOP STORIES")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.gray)
                
                Spacer()
                
                NavigationLink {
                    ListView(listType: .story)
                        .environmentObject(viewModel)
                } label: {
                    Text("SEE ALL")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.blue)
                }
                
            }
            
            Rectangle()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, maxHeight: 1)
            
            List {
                ForEach(viewModel.topStories.prefix(5)) { story in
                    
                    NavigationLink {
                        if let storyURL = story.url {
                            DetailView(itemURL: storyURL, itemKids: story.kids, itemID: story.id)
                                .environmentObject(viewModel)
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(story.title)
                                .font(.system(size: 12, design: .monospaced))
                            
                            HStack {
                                Text("\(story.descendants) comments")
                                Image(systemName: "arrow.up")
                                Text("\(story.score)")
                                Spacer()
                                Text(story.by)
                                Text("•")
                                Text("\(story.relativeTimeString)")
                            }
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.secondary)
                        }
                        .listRowSeparatorTint(.gray)
                        .listRowSeparator(.automatic, edges: .all)
                        .padding(5)
                        .padding(.horizontal, -10)
                    }
                    
                }
            }
            .scrollDisabled(true)
            .padding(.vertical, -20)
            .padding(.horizontal, -15)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .gray, radius: 4, x: -1, y: 2)
            .scrollContentBackground(.hidden)
            .frame(height: 425)
        }
        .padding(.horizontal)
    }
    
    var topJobsView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("TOP JOBS")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(.gray)
                
                Spacer()
                
                NavigationLink {
                    ListView(listType: .job)
                        .environmentObject(viewModel)
                } label: {
                    Text("SEE ALL")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.blue)
                }
                
            }
            
            Rectangle()
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, maxHeight: 1)
            
            List {
                ForEach(viewModel.topJobs.prefix(5)) { job in
                    
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
                            .font(.system(size: 12, design: .monospaced))
                            .listRowSeparatorTint(.gray)
                            .listRowSeparator(.automatic, edges: .all)
                            .padding(8)
                            .padding(.horizontal, -15)
                    }
                    
                }
            }
            .scrollDisabled(true)
            .padding(-15)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .gray, radius: 4, x: -1, y: 2)
            .scrollContentBackground(.hidden)
            .frame(height: 450)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
