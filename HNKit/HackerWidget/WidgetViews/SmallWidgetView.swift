//
//  SmallWidgetView.swift
//  HNKit
//
//  Created by Luke Atkins on 4/9/24.
//

import Foundation
import SwiftUI
import Neumorphic

struct SmallWidgetView: View {
    var storyIndex: Int
    var entry: SimpleEntry
    
    init(storyIndex: Int, entry: SimpleEntry) {
        self.storyIndex = storyIndex
        self.entry = entry
    }
    
    var body: some View {
        // raied widget
        // raised platform
        switch entry.configuration.itemType {
        case "Story":
            storyView
        case "Job":
            jobView
        default:
            storyView
        }

        
    }
    
    var storyView: some View {
        
        VStack {
            Text("TOP STORY")
                .font(.system(size: 8, design: .monospaced))
                .foregroundStyle(.gray)
            
            
            Spacer()
            
            if entry.myStories.isEmpty {
                ProgressView()
            } else {
                Text(entry.myStories[0].title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16)).bold()
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.65)
                    .frame(maxWidth: .infinity)
                    .padding(5)
                
                HStack {
                    Text("\(entry.myStories[0].by) • \(entry.myStories[0].relativeTimeString)")
                        .font(.system(size: 8)).bold()
                    Spacer()
                    HStack {
                        Text("\(entry.myStories[0].score)")
                        Image(systemName: "arrow.up")
                    }
                    .font(.system(size: 8)).bold()
                }
            }
        
            
            
            Spacer()
            
        }
    }
    
    var jobView: some View {
        VStack {
            Text("TOP JOB")
                .font(.system(size: 8, design: .monospaced))
                .foregroundStyle(.gray)
            
            
            Spacer()
            
            if entry.myJobs.isEmpty {
                ProgressView()
            } else {
                Text(entry.myJobs[storyIndex].title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16)).bold()
                    .foregroundStyle(.black)
                    .minimumScaleFactor(0.65)
                    .frame(maxWidth: .infinity)
                    .padding(5)
                
            }
            // need intent here because th';;p;e interactive widget
            Spacer()
            
        }
    }
}
