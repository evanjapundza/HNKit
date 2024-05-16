//
//  ThemeManager.swift
//  HNKit
//
//  Created by Evan Japundza on 5/14/24.
//

import Foundation

enum ThemeManager {
    static let themes : [Theme] = [Theme1(), Theme2(), Theme3()]
    
    static func getTheme(_ theme: Int) -> Theme {
        Self.themes[theme]
    }
}
