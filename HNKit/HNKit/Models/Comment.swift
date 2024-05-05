//
//  Comment.swift
//  HNKit
//
//  Created by Evan Japundza on 4/16/24.
//

import Foundation

struct Comment: Decodable, Identifiable {
    let id: Int
    let by: String
    let kids: [Int]?
    let parent: Int
    let text: String
    let time: TimeInterval
    let type: String
    var nestedComments: [Comment]?
    
    var date: Date {
        return Date(timeIntervalSince1970: time)
    }
    
    var relativeTimeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
