//
//  AppIntent.swift
//  HackerWidget
//
//  Created by Luke Atkins on 3/24/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Widget Item Type"
    static var description = IntentDescription("Select which type of item you would like to display on the widget, either stories or jobs.")

    // An example configurable parameter.
    @Parameter(title: "Item Type")
    var itemType: String
}
