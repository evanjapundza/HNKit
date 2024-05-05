//
//  HackerWidgetLiveActivity.swift
//  HackerWidget
//
//  Created by Luke Atkins on 3/24/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HackerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HackerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HackerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HackerWidgetAttributes {
    fileprivate static var preview: HackerWidgetAttributes {
        HackerWidgetAttributes(name: "World")
    }
}

extension HackerWidgetAttributes.ContentState {
    fileprivate static var smiley: HackerWidgetAttributes.ContentState {
        HackerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HackerWidgetAttributes.ContentState {
         HackerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HackerWidgetAttributes.preview) {
   HackerWidgetLiveActivity()
} contentStates: {
    HackerWidgetAttributes.ContentState.smiley
    HackerWidgetAttributes.ContentState.starEyes
}
