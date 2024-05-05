//
//  HackerNewsAPI.swift
//  HNKit
//
//  Created by Luke Atkins on 3/24/24.
//

import Foundation

class HackerNewsAPI {
    static let shared = HackerNewsAPI()
    
    private let baseURL = "https://hacker-news.firebaseio.com/v0"
    
    
    func fetchTopStoryIDs(completion: @escaping ([Int]?) -> Void) {
        let url = URL(string: "\(baseURL)/topstories.json")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let storyIDs = try? JSONDecoder().decode([Int].self, from: data)
                completion(storyIDs)
            } else {
                print("Error fetching top stories: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
        
    }
    
    
    func fetchTopStories(ids: [Int], completion: @escaping ([Story]?) -> Void) {
        var stories: [Story] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            fetchStory(id: id) { story in
                if let story = story {
                    stories.append(story)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(stories)
        }
    }
    
    func fetchStory(id: Int, completion: @escaping (Story?) -> Void) {
        let url = URL(string: "\(baseURL)/item/\(id).json")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let story = try? JSONDecoder().decode(Story.self, from: data)
                completion(story)
            } else {
                print("Error fetching story with ID \(id): \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchTopJobsIDs(completion: @escaping ([Int]?) -> Void) {
        let url = URL(string: "\(baseURL)/jobstories.json")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let storyIDs = try? JSONDecoder().decode([Int].self, from: data)
                completion(storyIDs)
            } else {
                print("Error fetching top stories: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
        
    }
    
    func fetchTopJobs(ids: [Int], completion: @escaping ([Job]?) -> Void) {
        var jobs: [Job] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            fetchJob(id: id) { job in
                if let job = job {
                    jobs.append(job)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(jobs)
        }
    }
    
    func fetchJob(id: Int, completion: @escaping (Job?) -> Void) {
        let url = URL(string: "\(baseURL)/item/\(id).json")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let job = try? JSONDecoder().decode(Job.self, from: data)
                completion(job)
            } else {
                print("Error fetching story with ID \(id): \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
    
    func fetchComment(for commentID: Int, completion: @escaping (Comment?) -> Void) {
        let urlString = "https://hacker-news.firebaseio.com/v0/item/\(commentID).json"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let comment = try JSONDecoder().decode(Comment.self, from: data)
                self.fetchNestedComments(for: comment, completion: completion)
            } catch {
                print("Error decoding comment: \(error)")
                completion(nil)
            }
        }.resume()
    }

    
    private func fetchNestedComments(for comment: Comment, completion: @escaping (Comment) -> Void) {
        guard let childCommentIDs = comment.kids, !childCommentIDs.isEmpty else {
            completion(comment) // Directly return if there are no nested comments.
            return
        }

        let group = DispatchGroup()
        var nestedComments = [Comment]()

        for childID in childCommentIDs {
            group.enter()
            fetchComment(for: childID) { nestedComment in
                if let nestedComment = nestedComment {
                    nestedComments.append(nestedComment)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            var updatedComment = comment
            updatedComment.nestedComments = nestedComments.sorted(by: { $0.id < $1.id })
            completion(updatedComment)
        }
    }
}
