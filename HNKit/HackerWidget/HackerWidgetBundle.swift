//
//  HackerWidgetBundle.swift
//  HackerWidget
//
//  Created by Luke Atkins on 3/24/24.
//

import WidgetKit
import SwiftUI

@main
struct HackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        HackerWidget()
        HackerWidgetLiveActivity()
    }
}
