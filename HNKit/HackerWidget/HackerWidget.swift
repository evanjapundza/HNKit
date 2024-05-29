//
//  HackerWidget.swift
//  HackerWidget
//
//  Created by Luke Atkins on 3/24/24.
//

import WidgetKit
import SwiftUI


final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    private var cachedStories: [Story]? {
        didSet{
            lastCachedDate = .now
        }
    }
    
    private var cachedJobs: [Job]? {
        didSet{
            lastCachedDate = .now
        }
    }
    
    
    private var lastCachedDate: Date?
    
    private var storyHasCacheUnder60min: Bool {
        if cachedStories != nil, let lastCachedDate, Date.now.timeIntervalSince(lastCachedDate) < 60 * 60 {
            return true
        } else{
            return false
        }
    }
    
    private var jobHasCacheUnder60min: Bool {
        if cachedJobs != nil, let lastCachedDate, Date.now.timeIntervalSince(lastCachedDate) < 60 * 60 {
            return true
        } else{
            return false
        }
    }
    
    
    
    func fetchStories() async -> [Story]{
        if let cachedStories, storyHasCacheUnder60min{
            return cachedStories
        }
        
        let stories = await getTopTenStories()
        self.cachedStories = stories
        return stories
    }
    
    func fetchJobs() async -> [Job]{
        if let cachedJobs, jobHasCacheUnder60min{
            return cachedJobs
        }
        
        let jobs = await getTopTenJobs()
        self.cachedJobs = jobs
        return jobs
    }
    
    private func getTopTenStories() async -> [Story] {
        // have this get the top ten stories and return it
        await withCheckedContinuation { continuation in
            HackerNewsAPI.shared.fetchTopStoryIDs { storyIDs in
                guard let storyIDs = storyIDs else {
                    continuation.resume(returning: [])
                    return
                }
                
                let limitedIDs = Array(storyIDs.prefix(10))
                HackerNewsAPI.shared.fetchTopStories(ids: limitedIDs) { stories in
                    continuation.resume(returning: stories ?? [])
                }
            }
        }
    }
    
    private func getTopTenJobs() async -> [Job] {
        // have this get the top ten stories and return it
        await withCheckedContinuation { continuation in
            HackerNewsAPI.shared.fetchTopJobsIDs { jobIDs in
                guard let jobIDs = jobIDs else {
                    continuation.resume(returning: [])
                    return
                }
                
                let limitedIDs = Array(jobIDs.prefix(10))
                HackerNewsAPI.shared.fetchTopJobs(ids: limitedIDs) { jobs in
                    continuation.resume(returning: jobs ?? [])
                }
            }
        }
    }
}

struct Provider: AppIntentTimelineProvider {
    static var storyIndex: Int = 0
   
    
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), itemType: WidgetItemType.types[0], myStories: [dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory], myJobs: [dummyJob])
    }
    
    func snapshot(for configuration: SelectItemType, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), itemType: configuration.itemType, myStories: [dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory, dummyStory], myJobs: [dummyJob])
    }
    
    func timeline(for configuration: SelectItemType, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        // woah

        
        switch configuration.itemType.id {
        case "Story":
            let fetchedStories = await NetworkManager.shared.fetchStories()
            
            for hourOffset in 0 ..< 18 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, itemType: configuration.itemType, myStories: fetchedStories, myJobs: [])
                entries.append(entry)
            }
        case "Job":
            let fetchedJobs = await NetworkManager.shared.fetchJobs()
            
            for hourOffset in 0 ..< 18 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, itemType: configuration.itemType, myStories: [], myJobs: fetchedJobs)
                entries.append(entry)
            }
        default:
            _ = await NetworkManager.shared.fetchStories()
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let itemType: WidgetItemType
    let myStories: [Story]
    let myJobs: [Job]
}
// color for nuewmorhpic bros
extension Color{
    static let offWhite = Color(red: 243 / 255, green: 243 / 255, blue: 243 / 255)
}

struct HackerWidgetEntryView : View {
    @StateObject private var viewModel = HackerNewsViewModel()
    var entry: Provider.Entry
    
    @State var storyIndex = Provider.storyIndex
    
    @Environment(\.widgetFamily) var family
        
    @ViewBuilder
    var body: some View {
        switch family{
        
        case .systemSmall:
            SmallWidgetView(storyIndex: storyIndex, entry: entry)
                .preferredColorScheme(.light)
                .ignoresSafeArea()
        case .systemMedium:
            MediumWidgetView(storyIndex: storyIndex, entry: entry)
                .preferredColorScheme(.light)
        case .systemLarge:
            Text("not done yet")
        case .systemExtraLarge:
            Text("not done yet")
        case .accessoryCircular:
            Text("not done yet")
        case .accessoryRectangular:
            Text("not done yet")
        case .accessoryInline:
            Text("not done yet")
        @unknown default:
            Text("not done yet")
        
        }
    }
}


struct HackerWidget: Widget {
    let kind: String = "HackerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectItemType.self, provider: Provider()) { entry in
            HackerWidgetEntryView(entry: entry)
                .containerBackground(Color.offWhite, for: .widget)
            
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
        .configurationDisplayName("Top 10")
        .description("Display the current top 10 stories or jobs.")
    }
}


#Preview(as: .systemSmall) {
    HackerWidget()
} timeline: {
    SimpleEntry(date: .now, itemType: WidgetItemType.types[0], myStories: [dummyStory,dummyStory,dummyStory,dummyStory,dummyStory,dummyStory,dummyStory,dummyStory,dummyStory,dummyStory], myJobs: [dummyJob])
    SimpleEntry(date: .now, itemType: WidgetItemType.types[1], myStories: [dummyStory], myJobs: [dummyJob])
}

let dummyStory = Story(
    id: 12345,
    title: "Breaking News: Scientists Discover New Planet in Nearby Solar System",
    url: "https://example.com/news/new-planet-discovered",
    score: 987,
    time: 1648234567,
    by: "space_enthusiast",
    descendants: 42,
    kids: [54321, 67890],
    type: "story",
    text: "In a groundbreaking discovery, astronomers have identified a new Earth-like planet orbiting a nearby star. The planet, named Kepler-1649c, is located in the habitable zone and has the potential to support life. Scientists are excited about the possibilities this discovery brings and are eagerly planning further observations to study the planet's atmosphere and potential for harboring extraterrestrial life forms."
)

let dummyJob = Job(id: 12345, title: "Apple is Hiring!", url: "www.google.com", score: 50, time: 123435232, by: "evan", type: "job", text: "")
