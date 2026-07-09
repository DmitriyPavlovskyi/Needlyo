import SwiftUI

/// Central semantic colors for the Needlyo visual system.
enum NeedlyoColors {
    static let background = Color(hex: 0xFAFAF5)
    static let surface = Color(hex: 0xFFFFFF)
    static let surfaceSubtle = Color(hex: 0xF2F5EE)
    static let border = Color(hex: 0xE3E7DD)
    static let primary = Color(hex: 0x7FB76F)
    static let primaryStrong = Color(hex: 0x648E57)
    static let primarySoft = Color(hex: 0xD8E7CD)
    static let primaryText = Color(hex: 0xFFFFFF)
    static let textPrimary = Color(hex: 0x20281D)
    static let textSecondary = Color(hex: 0x5F6959)
    static let destructive = Color(hex: 0xD97B7B)
}

extension Color {
    static let appBackground = NeedlyoColors.background
    static let appSurface = NeedlyoColors.surface
    static let appSurfaceSubtle = NeedlyoColors.surfaceSubtle
    static let appBorder = NeedlyoColors.border
    static let appPrimary = NeedlyoColors.primary
    static let appPrimaryStrong = NeedlyoColors.primaryStrong
    static let appPrimarySoft = NeedlyoColors.primarySoft
    static let appPrimaryText = NeedlyoColors.primaryText
    static let appTextPrimary = NeedlyoColors.textPrimary
    static let appTextSecondary = NeedlyoColors.textSecondary
    static let appDestructive = NeedlyoColors.destructive
}

private extension Color {
    init(hex: UInt32) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
