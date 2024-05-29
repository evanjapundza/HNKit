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
    
    @State var currentStory: Story = Story(id: 0001, title: "test", url: "www.google.com", score: 50, time: TimeInterval(), by: "eazy", descendants: 5, type: "story")
    @State var currentJob: Job = Job(id: 0001, title: "test job", url: "www.google.com", score: 50, time: TimeInterval(), by: "evan", type: "job", text: "job")
    
    
    @State var sheetPresented: Bool = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {

                Color(viewModel.selectedTheme.B) // #ecefff
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                
                                Text(Date.now.formatted(date: .long, time: .omitted))
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)
                                    .foregroundStyle(Color(viewModel.selectedTheme.H))
                                
                                Spacer()
                            }
                            
                            TabView {
                                
                                topStoryView
                                
                                topJobView
                                
                            }
                            .frame(minHeight: 400)
                            .tabViewStyle(.page(indexDisplayMode: .always))
                            .onAppear {
                                UIPageControl.appearance().currentPageIndicatorTintColor = viewModel.selectedTheme.H
                                UIPageControl.appearance().pageIndicatorTintColor = viewModel.selectedTheme.H.withAlphaComponent(0.4)
                            }
                            
                            topStoriesView
                            
                            topJobsView
                            
                            Spacer()
                        }
                    }
                    .navigationDestination(for: Job.self) { job in
                        DetailView(job: job, itemType: ItemType.job)
                            .environmentObject(viewModel)
                    }
                    .navigationDestination(for: Story.self) { story in
                        DetailView(story: story, itemType: ItemType.story)
                            .environmentObject(viewModel)
                    }
                    .toolbar {
                        ToolbarItem {
                            
                            NavigationLink {
                                SettingsView()
                                    .tint(Color(viewModel.selectedTheme.H))
                                    .environmentObject(viewModel)
                            } label: {
                                Image(systemName: "gearshape.fill")
                                    .foregroundStyle(Color(viewModel.selectedTheme.F))
                            }
                        }
                    }
                    .onOpenURL(perform: { (url) in
                        let type = url.host
                        let id = Int(url.pathComponents[1])
                        print(type ?? "none")
                        Task {
                            switch type {
                            case "story":
                                currentStory = await viewModel.fetchStory(withID: id!)!
                                navigationPath.append(currentStory)
                            case "job":
                                currentJob = await viewModel.fetchJob(withID: id!)!
                                navigationPath.append(currentJob)
                            default:
                                currentStory = await viewModel.fetchStory(withID: id!)!
                                navigationPath.append(currentStory)
                            }
                            
                        }
                        
                    })
                    .refreshable {
                        viewModel.fetchTopStories()
                        viewModel.fetchTopJobs()
                    }
                    
                }
                
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
        .onAppear {
            viewModel.fetchTopStories()
            viewModel.fetchTopJobs()
        }
        
    }
    
    var topStoryView: some View {
        VStack(alignment: .leading) {
            Text("TOP STORY")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(Color(viewModel.selectedTheme.G))
                .padding(.horizontal)
            
            NavigationLink {
                if let topstory = viewModel.topStories.first {
                    DetailView(story: topstory, itemType: ItemType.story)
                        .environmentObject(viewModel)
                }
            } label: {
                
                VStack(alignment: .leading) {
                    
                    
                    if let topstory = viewModel.topStories.first {
                        
                        GeometryReader { reader in
                            VStack(spacing: 0) {
                                VStack(alignment: .leading) {
                                    Spacer()
                                    HStack {
                                        Text(topstory.title)
                                            .multilineTextAlignment(.leading)
                                            .font(.system(size: 48))
                                            .minimumScaleFactor(0.6)
                                            .foregroundStyle(Color(viewModel.selectedTheme.A))
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    Text("🔗 " + (topstory.url ?? ""))
                                        .fontWeight(.ultraLight)
                                        .font(.system(size: 12, design: .monospaced))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.85)
                                        .foregroundStyle(Color(viewModel.selectedTheme.A))
                                }
                                .padding()
                                .frame(width: reader.size.width, height: reader.size.height * 0.75)
                                
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    
                                    LinearGradient(colors: [Color(red: 0.604, green: 0.643, blue: 1), Color(red: 0.357, green: 0.314, blue: 1)], startPoint: .top, endPoint: .bottom)
                                        .frame(height: 4)
                                        .opacity(0.8)
                                        .padding(.horizontal, -20)
                                        .padding(.top, -20)
                                    
                                    Text("\(topstory.by) • \(topstory.relativeTimeString)")
                                        .foregroundStyle(Color(viewModel.selectedTheme.A))
                                    
                                    HStack {
                                        Text("\(topstory.descendants) comments")
                                            .foregroundStyle(Color(viewModel.selectedTheme.A))
                                        
                                        Text("↑\(topstory.score)")
                                            .foregroundStyle(Color(viewModel.selectedTheme.A))
                                        
                                    }
                                }
                                .padding()
                                .frame(height: reader.size.height * 0.25)
                            }
                        }
                    }
                    Spacer()
                }
                .foregroundStyle(Color(viewModel.selectedTheme.A))
                .frame(height: 320)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.443, green: 0.451, blue: 1), Color(red: 0.357, green: 0.314, blue: 1)]), startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: Color(viewModel.selectedTheme.L), radius: 4, x: -1, y: 2)
                .padding(.horizontal)
                
            }
            
            Spacer()
        }
        
    }
    
    var topJobView: some View {
        
        VStack(alignment: .leading) {
            Text("TOP JOB")
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(Color(viewModel.selectedTheme.G))
                .padding(.horizontal)
            
            NavigationLink {
                if let topJob = viewModel.topJobs.first {
                    DetailView(job: topJob, itemType: ItemType.job)
                        .environmentObject(viewModel)
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
            .foregroundStyle(Color(viewModel.selectedTheme.A))
            .frame(height: 320)
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.443, green: 0.451, blue: 1), Color(red: 0.357, green: 0.314, blue: 1)]), startPoint: .top, endPoint: .bottom))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color(viewModel.selectedTheme.L), radius: 4, x: -1, y: 2)
            .padding(.horizontal)

            Spacer()
        }
    }
    
    var topStoriesView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("TOP STORIES")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Color(viewModel.selectedTheme.G))
                
                Spacer()
                
                NavigationLink {
                    ListView(listType: .story)
                        .environmentObject(viewModel)
                } label: {
                    HStack {
                        Text("SEE ALL")
                            
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Color(viewModel.selectedTheme.F))
                    .font(.system(size: 12, design: .monospaced))
                }
                
            }
            
            Rectangle()
                .foregroundStyle(Color(red: 0.357, green: 0.314, blue: 1))
                .frame(maxWidth: .infinity, maxHeight: 1)
            
            List {
                ForEach(viewModel.topStories.prefix(5)) { story in
                    
                    NavigationLink {
                        DetailView(story: story, itemType: ItemType.story)
                            .environmentObject(viewModel)
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
                        }
                        .listRowSeparator(.automatic, edges: .all)
                        .padding(5)
                        .padding(.horizontal, -10)
                    }
                    .frame(height: 60)
                    .foregroundStyle(Color(viewModel.selectedTheme.A))
                    .listRowBackground(Color(red: 0.357, green: 0.314, blue: 1))
                    .listRowSeparatorTint(Color(red: 0.188, green: 0.137, blue: 0.549))
                    
                    
                }
            }
            .scrollDisabled(true)
            .padding(.vertical, -20)
            .padding(.horizontal, -15)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color(viewModel.selectedTheme.L), radius: 4, x: -1, y: 2)
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
                    .foregroundStyle(Color(viewModel.selectedTheme.G))
                
                Spacer()
                
                NavigationLink {
                    ListView(listType: .job)
                        .environmentObject(viewModel)
                } label: {
                    HStack {
                        Text("SEE ALL")
                        
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Color(viewModel.selectedTheme.F))
                    .font(.system(size: 12, design: .monospaced))
                }
                
            }
            
            Rectangle()
                .foregroundStyle(Color(red: 0.357, green: 0.314, blue: 1))
                .frame(maxWidth: .infinity, maxHeight: 1)
            
            List {
                ForEach(viewModel.topJobs.prefix(5)) { job in
                    
                    NavigationLink {
                        DetailView(job: job, itemType: ItemType.job)
                            .environmentObject(viewModel)
                    } label: {
                        Text(job.title)
                            .foregroundStyle(Color(viewModel.selectedTheme.A))
                            .font(.system(size: 12, design: .monospaced))
                            .listRowSeparator(.automatic, edges: .all)
                            .padding(8)
                            .padding(.horizontal, -15)
                    }
                    .frame(height: 60)
                    .foregroundStyle(Color(viewModel.selectedTheme.A))
                    .listRowBackground(Color(red: 0.357, green: 0.314, blue: 1))
                    .listRowSeparatorTint(Color(red: 0.188, green: 0.137, blue: 0.549))
                    
                }
            }
            .scrollDisabled(true)
            .padding(-15)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color(viewModel.selectedTheme.L), radius: 4, x: -1, y: 2)
            .scrollContentBackground(.hidden)
            .frame(height: 450)
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
