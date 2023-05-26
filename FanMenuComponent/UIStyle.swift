import SwiftUI
import UIKit

extension Color {
    static let MELDRed1 = UIStyle.shared.MELDRed1
    static let MELDRed2 = UIStyle.shared.MELDRed2
    static let MELDCyan = UIStyle.shared.MELDCyan
    static let MELDNavy = UIStyle.shared.MELDNavy
    static let appBackground = UIStyle.shared.appBackground
    static let tileGrayBackground = UIStyle.shared.tileGrayBackground
    static let tileGrayTitle = UIStyle.shared.tileGrayTitle
    static let tileLightGrayTitle = UIStyle.shared.tileLightGrayTitle
}

extension UIColor {
    static let MELDRed1 = UIColor(cgColor: UIStyle.shared.MELDRed1.cgColor!)
    static let MELDRed2 = UIColor(cgColor: UIStyle.shared.MELDRed2.cgColor!)
    static let MELDCyan = UIColor(cgColor: UIStyle.shared.MELDCyan.cgColor!)
    static let MELDNavy = UIColor(cgColor: UIStyle.shared.MELDNavy.cgColor!)
    static let appBackground = UIColor(cgColor: UIStyle.shared.appBackground.cgColor!)
    static let tileGrayBackground = UIColor(cgColor: UIStyle.shared.tileGrayBackground.cgColor!)
    static let tileGrayTitle = UIColor(cgColor: UIStyle.shared.tileGrayTitle.cgColor!)
    static let tileLightGrayTitle = UIColor(cgColor: UIStyle.shared.tileLightGrayTitle.cgColor!)
}

private struct UIStyle {
    
    static let shared = Self()
    
    private init() {}
    
    let MELDRed1 = Color(red: 229 / 255, green: 27 / 255, blue: 68 / 255)
    let MELDRed2 = Color(red: 203 / 255, green: 26 / 255, blue: 79 / 255)
    let MELDCyan = Color(red: 26 / 255, green: 252 / 255, blue: 255 / 255)
    let MELDNavy = Color(red: 24 / 255, green: 13 / 255, blue: 113 / 255)
    let appBackground = Color(red: 247 / 255, green: 245 / 255, blue: 248 / 255)
    let tileGrayBackground = Color(red: 255 / 255, green: 254 / 255, blue: 255 / 255)
    let tileGrayTitle = Color(red: 162 / 255, green: 159 / 255, blue: 166 / 255)
    let tileLightGrayTitle = Color(red: 197 / 255, green: 197 / 255, blue: 199 / 255)
}
