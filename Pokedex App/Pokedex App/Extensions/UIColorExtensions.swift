//
//  UIColorExtensions.swift
//  Pokedex App
//
//  Created by Cesar Castillo on 25-03-25.
//

import UIKit

extension UIColor {
    
    static func color(from hex: String, alpha: CGFloat = 1.0) -> UIColor? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        guard hexSanitized.count == 6, let rgb = UInt64(hexSanitized, radix: 16) else {
            return nil
        }
    
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
