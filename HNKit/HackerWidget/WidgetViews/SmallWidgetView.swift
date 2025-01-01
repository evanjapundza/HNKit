//
//  SmallWidgetView.swift
//  ObserveHN
//
//  Created by Luke Atkins on 4/9/24.
//

import Foundation
import SwiftUI

struct SmallWidgetView: View {
    var storyIndex: Int
    var entry: SimpleEntry
    
    init(storyIndex: Int, entry: SimpleEntry) {
        self.storyIndex = storyIndex
        self.entry = entry
    }
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(._1_B.gradient)
            
            switch entry.itemType.id {
            case "Story":
                storyView
                    .padding()
            case "Job":
                jobView
                    .padding()
            default:
                storyView
                    .padding()
            }
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
                Group {
                    Text(entry.myStories[0].title)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16)).bold()
                        .minimumScaleFactor(0.65)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                    
                    Spacer()
                    
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
                .foregroundStyle(._1_K)
            }
        
            
            
            
        }
        .widgetURL(URL(string: "ObserveHN://story/\(entry.myStories[0].id)")!)
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
                Text(entry.myJobs[0].title)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16)).bold()
                    .foregroundStyle(._1_K)
                    .minimumScaleFactor(0.65)
                    .frame(maxWidth: .infinity)
                    .padding(5)
                
            }

            Spacer()
            
        }
        .widgetURL(URL(string: "ObserveHN://job/\(entry.myJobs[0].id)")!)
    }
}
