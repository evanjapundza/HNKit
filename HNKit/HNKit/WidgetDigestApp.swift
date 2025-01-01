//
//  HNKitApp.swift
//  HNKit
//
//  Created by Evan Japundza on 3/24/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics

@main
struct HNKitApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .tint(Color(red: 0.318, green: 0.212, blue: 0.961))
        }
    }
}
