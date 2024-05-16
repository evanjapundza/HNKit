//
//  HNKitApp.swift
//  HNKit
//
//  Created by Evan Japundza on 3/24/24.
//

import SwiftUI

@main
struct HNKitApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
//                .preferredColorScheme(.light)
                .tint(Color(red: 0.122, green: 0.086, blue: 0.314))
        }
    }
}
