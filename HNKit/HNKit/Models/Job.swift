//
//  Job.swift
//  HNKit
//
//  Created by Evan Japundza on 4/1/24.
//

import Foundation


struct Job: Hashable, Codable, Identifiable {
    
    let id: Int
    let title: String
    let url: String?
    var score: Int
    let time: TimeInterval
    let by: String
    var type: String
    let text: String?
    
    var date: Date {
        return Date(timeIntervalSince1970: time)
    }
    
    var relativeTimeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
}
