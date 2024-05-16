//
//  MediumWidgetView.swift
//  HNKit
//
//  Created by Luke Atkins on 4/9/24.
//

import Foundation
import SwiftUI
import Neumorphic


struct MediumWidgetView: View {
    var storyIndex: Int
    var entry: SimpleEntry
    
    init(storyIndex: Int, entry: SimpleEntry) {
        self.storyIndex = storyIndex
        self.entry = entry
    }
    
    var body: some View {
        switch entry.configuration.itemType {
        case "Story":
            storyView
                .widgetURL(URL(string: "HNKit://detailview/1"))
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
            Link(destination: URL(string: "HNKit://")!) {
                if entry.myStories.isEmpty {
                    ProgressView()
                } else {
                    Text(entry.myStories[storyIndex].title)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 20)).bold()
                        .foregroundStyle(.black)
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
                .padding(.horizontal, 5)
                
                
                HStack {
                    Spacer()
                    
                    Spacer()
                    
                    Spacer()
                    
                    HStack(alignment: .center,spacing: 8) {
                        ForEach(0..<entry.myStories.count, id: \.self) { index in
                            withAnimation {
                                if index == storyIndex {
                                    Circle()
                                        .foregroundStyle(.black)
                                        .frame(height: 6)
                                }
                                else {
                                    Circle()
                                        .foregroundStyle(.gray)
                                        .frame(height: 5)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    Button(intent: NextStory()){
                        Text("next")
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.gray)
                            .frame(width: 30, height: 3)
                        
                    }
                    .softButtonStyle(RoundedRectangle(cornerRadius: 20), pressedEffect: .hard)
                }
                .padding(.horizontal, 8)
            }
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
            Spacer()
            HStack {
                ProgressView(value: Float(storyIndex)/10)
                Spacer()
                Button(intent: NextStory()){
                    Text("next")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.gray)
                        .frame(width: 30, height: 4)
                    
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: 20), pressedEffect: .flat)
            }
        }
    }
    
}
