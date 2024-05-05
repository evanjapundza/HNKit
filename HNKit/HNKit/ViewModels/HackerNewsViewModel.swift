import Foundation

class HackerNewsViewModel: ObservableObject {
    @Published var topStoryIDX: Int = 0
    @Published var topStories: [Story] = [
        Story(
            id: 00001,
            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
            url: "www.google.com",
            score: 449,
            time: 10.0,
            by: "alt-glitch",
            descendants: 49,
            type: "story"
        ),
        Story(
            id: 00002,
            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
            url: "www.google.com",
            score: 449,
            time: 10.0,
            by: "alt-glitch",
            descendants: 49,
            type: "story"
        ),
        Story(
            id: 00003,
            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
            url: "www.google.com",
            score: 449,
            time: 10.0,
            by: "alt-glitch",
            descendants: 49,
            type: "story"
        ),
        Story(
            id: 00004,
            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
            url: "www.google.com",
            score: 449,
            time: 10.0,
            by: "alt-glitch",
            descendants: 49,
            type: "story"
        ),
        Story(
            id: 00005,
            title: "Safeguarding Identity and Privacy: Fundamental Human Rights in the Digital Age",
            url: "www.google.com",
            score: 449,
            time: 10.0,
            by: "alt-glitch",
            descendants: 49,
            type: "story"
        )
    ]
    
    @Published var topJobs: [Job] = []
    @Published var isLoading = false
    
    @Published var storyComments: [Comment] = []
    
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
    
    
}
