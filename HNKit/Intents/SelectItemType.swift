//
//  WidgetItemType.swift
//  HackerWidgetExtension
//
//  Created by Evan Japundza on 5/20/24.
//

import SwiftUI
import AppIntents

struct WidgetItemType: AppEntity {
    
    static var defaultQuery = WidgetItemQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Item Type"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
    
    var id: String
    
    static let types: [WidgetItemType] = [
        WidgetItemType(id: "Story"),
        WidgetItemType(id: "Job")
    ]
    
}

struct WidgetItemQuery: EntityQuery {
    func entities(for identifiers: [WidgetItemType.ID]) async throws -> [WidgetItemType] {
        WidgetItemType.types.filter {
            identifiers.contains($0.id)
        }
    }
    
    func suggestedEntities() async throws -> [WidgetItemType] {
        WidgetItemType.types
    }
    
    func defaultResult() async -> WidgetItemType? {
        WidgetItemType.types.first
    }
}

struct SelectItemType: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Widget Item Type"
    static var description = IntentDescription("Select which type of item you would like to display on the widget, either stories or jobs.")

    @Parameter(title: "Item Type")
    var itemType: WidgetItemType
}
