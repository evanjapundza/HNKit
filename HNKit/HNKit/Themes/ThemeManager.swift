//
//  ThemeManager.swift
//  HNKit
//
//  Created by Evan Japundza on 5/14/24.
//

import Foundation

enum ThemeManager {
    static let themes : [Theme] = [Default()]
    
    static func getTheme(_ theme: Int) -> Theme {
        Self.themes[theme]
    }
}
