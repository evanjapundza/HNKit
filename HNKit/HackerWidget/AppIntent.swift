//
//  AppIntent.swift
//  HackerWidget
//
//  Created by Luke Atkins on 3/24/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Item Type", default: "Job")
    var itemType: String
}
