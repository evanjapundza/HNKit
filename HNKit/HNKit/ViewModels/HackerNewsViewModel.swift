import Foundation
import SwiftUI

@MainActor
class HackerNewsViewModel: ObservableObject {
    @Published var topStories: [Story] = [
//        Story(
//            id: 00001,
//            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
//            url: "www.google.com",
//            score: 449,
//            time: 10.0,
//            by: "alt-glitch",
//            descendants: 49,
//            type: "story"
//        ),
//        Story(
//            id: 00002,
//            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
//            url: "www.google.com",
//            score: 449,
//            time: 10.0,
//            by: "alt-glitch",
//            descendants: 49,
//            type: "story"
//        ),
//        Story(
//            id: 00003,
//            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
//            url: "www.google.com",
//            score: 449,
//            time: 10.0,
//            by: "alt-glitch",
//            descendants: 49,
//            type: "story"
//        ),
//        Story(
//            id: 00004,
//            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
//            url: "www.google.com",
//            score: 449,
//            time: 10.0,
//            by: "alt-glitch",
//            descendants: 49,
//            type: "story"
//        ),
//        Story(
//            id: 00005,
//            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
//            url: "www.google.com",
//            score: 449,
//            time: 10.0,
//            by: "alt-glitch",
//            descendants: 49,
//            type: "story"
//        )
    ]
    
    @Published var topJobs: [Job] = []
    @Published var isLoading = false
    
    @Published var storyComments: [Comment] = []
    
    @AppStorage("selectedTheme") var selectedThemeAS = 0 {
        didSet {
            updateTheme()
        }
    }
    @Published var selectedTheme : Theme = Default()
    
    func updateTheme() {
        selectedTheme = ThemeManager.getTheme(selectedThemeAS)
    }
    
    init() {
        updateTheme()
    }
    
    func fetchTopStories() {
        isLoading = true
        
        HackerNewsAPI.shared.fetchTopStoryIDs { [weak self] storyIDs in
            guard let storyIDs = storyIDs else { return }
            
            HackerNewsAPI.shared.fetchTopStories(ids: storyIDs) { [weak self] stories in
                DispatchQueue.main.async {
                    self?.topStories = stories ?? []
                    self?.isLoading = false
                }
            }
        }
    }
    
    func fetchTopJobs() {
        isLoading = true
        
        HackerNewsAPI.shared.fetchTopJobsIDs { [weak self] jobIDs in
            guard let jobIDs = jobIDs else { return }
            
            HackerNewsAPI.shared.fetchTopJobs(ids: jobIDs) { [weak self] jobs in
                DispatchQueue.main.async {
                    self?.topJobs = jobs ?? []
                    self?.isLoading = false
                }
            }
        }
    }
    
    func fetchTopLevelComments(for storyID: Int, completion: @escaping () -> Void) {
        
        
        let story = topStories.first{ $0.id == storyID }
        storyComments = []
        if let story = story {
            if let storyKids = story.kids {
                for comment in storyKids {
                    HackerNewsAPI.shared.fetchComment(for: comment) { [weak self] comment in
                        if let topLevelComment = comment {
                            self?.storyComments.append(topLevelComment)
                        }
                        completion()
                    }
                }
            }
        }
        
        
    }
    
    func fetchStory(withID id: Int) async -> Story? {
        isLoading = true
        
        return await withCheckedContinuation { continuation in
            HackerNewsAPI.shared.fetchStory(id: id) { story in
                DispatchQueue.main.async {
                    if let story = story {
                        continuation.resume(returning: story)
                    } else {
                        continuation.resume(returning: nil)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    func fetchJob(withID id: Int) async -> Job? {
        isLoading = true
        
        return await withCheckedContinuation { continuation in
            HackerNewsAPI.shared.fetchJob(id: id) { job in
                DispatchQueue.main.async {
                    if let job = job {
                        continuation.resume(returning: job)
                    } else {
                        continuation.resume(returning: nil)
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    
}
