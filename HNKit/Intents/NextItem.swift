//
//  NextItem.swift
//  HNKit
//
//  Created by Luke Atkins on 4/2/24.
//

import Foundation
import AppIntents
import WidgetKit
import SwiftUI

struct NextItem: AppIntent {
    
    static var title: LocalizedStringResource = "Next Story"
    static var description = IntentDescription("Changes index of current story to change to new story")
    
    func perform() async throws -> some IntentResult {
        if Provider.storyIndex == 9 {
            Provider.storyIndex = 0
        }
        else {
            Provider.storyIndex += 1
        }
        return .result()
    }
}

