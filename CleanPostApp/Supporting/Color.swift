//
//  Color.swift
//  CleanPostApp
//
//  Created by Ekaterina Saveleva on 19.05.2025.
//

import SwiftUI

// MARK: - Color Extension (Hex Support)

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        (r, g, b) = (
            (int >> 16) & 0xFF,
            (int >> 8) & 0xFF,
            int & 0xFF
        )
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255
        )
    }
}

