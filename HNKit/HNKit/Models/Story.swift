//
//  Story.swift
//  HNKit
//
//  Created by Luke Atkins on 3/24/24.
//

import Foundation

struct Story: Codable, Identifiable {
    
    let id: Int
    let title: String
    let url: String?
    var score: Int
    let time: TimeInterval
    let by: String
    var descendants: Int
    var kids: [Int]?
    var type: String
    var text: String?
    
    var date: Date {
        return Date(timeIntervalSince1970: time)
    }
    
    var relativeTimeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
}


