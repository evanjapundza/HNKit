//
//  MediumWidgetView.swift
//  HNKit
//
//  Created by Luke Atkins on 4/9/24.
//

import Foundation
import SwiftUI


struct MediumWidgetView: View {
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
        ZStack {
            VStack {
                Text("TOP STORIES")
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(._1_H)
                
                
                Spacer()
                Link(destination: URL(string: "HNKit://story/\(entry.myStories[storyIndex].id)")!) {
                    if entry.myStories.isEmpty {
                        ProgressView()
                    } else {
                        Text(entry.myStories[storyIndex].title)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 20)).bold()
                            .foregroundStyle(._1_K)
                            .minimumScaleFactor(0.65)
                            .frame(maxWidth: .infinity)
                            .padding(5)
                    }
                    Spacer()
                    HStack {
                        Text("\(entry.myStories[storyIndex].by) • \(entry.myStories[storyIndex].relativeTimeString)")
                            .font(.system(size: 8)).bold()
                        Spacer()
                        HStack {
                            Text("\(entry.myStories[storyIndex].score)")
                            Image(systemName: "arrow.up")
                        }
                        .font(.system(size: 8)).bold()
                    }
                    .foregroundStyle(._1_K)
                    .padding(.horizontal, 5)
                    
                    
                    HStack {
                        Spacer()
                        
                        Spacer()
                        
                        Spacer()
                        
                        Spacer()
                        
                        HStack(alignment: .center,spacing: 8) {
                            ForEach(0..<entry.myStories.count, id: \.self) { index in
                                withAnimation {
                                    if index == storyIndex {
                                        Circle()
                                            .foregroundStyle(._1_I)
                                            .frame(height: 6)
                                    }
                                    else {
                                        Circle()
                                            .foregroundStyle(._1_I.opacity(0.4))
                                            .frame(height: 5)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        Button(intent: NextItem()){
                            Text("next")
                                .frame(width: 30, height: 3)
                                .font(.system(size: 12, design: .monospaced))
                                .padding(7)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .tint(._1_F)
                        
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        
    }
    
    var jobView: some View {
        VStack {
            Text("TOP JOBS")
                .font(.system(size: 8, design: .monospaced))
                .foregroundStyle(.gray)
            
            
            Spacer()
            
            Link(destination: URL(string: "HNKit://job/\(entry.myJobs[storyIndex].id)")!) {
                
                if entry.myJobs.isEmpty {
                    ProgressView()
                } else {
                    Text(entry.myJobs[storyIndex].title)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16)).bold()
                        .foregroundStyle(._1_K)
                        .minimumScaleFactor(0.65)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                }
                Spacer()
                HStack {
                    Spacer()
                    
                    Spacer()
                    
                    Spacer()
                    
                    Spacer()
                    
                    HStack(alignment: .center,spacing: 8) {
                        ForEach(0..<entry.myJobs.count, id: \.self) { index in
                            withAnimation {
                                if index == storyIndex {
                                    Circle()
                                        .foregroundStyle(._1_K)
                                        .frame(height: 6)
                                }
                                else {
                                    Circle()
                                        .foregroundStyle(._1_K.opacity(0.4))
                                        .frame(height: 5)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    Button(intent: NextItem()){
                        Text("next")
                            .frame(width: 30, height: 3)
                            .font(.system(size: 12, design: .monospaced))
                            .padding(7)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(._1_F)
                    
                    
                }
                .padding(.horizontal, 8)
            }
        }
    }
    
}
