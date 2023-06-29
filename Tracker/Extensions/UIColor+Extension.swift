import UIKit

extension UIColor {
    // MARK: - Public properties
    static let ypBlackDay = UIColor(hex: 0x1A1B22)
    static let ypBlackNight = UIColor(hex: 0xFFFFFF)
    static let ypWhiteDay = UIColor(hex: 0xFFFFFF)
    static let ypWhiteNight = UIColor(hex: 0x1A1B22)
    static let ypGray = UIColor(hex: 0xAEAFB4)
    static let ypLightGray = UIColor(hex: 0xE6E8EB)
    static let ypBackgroundDay = UIColor(hex: 0xE6E8EB, alpha: 0.3)
    static let ypBackgroundNight = UIColor(hex: 0x414141, alpha: 0.85)
    static let ypRed = UIColor(hex: 0xF56B6C)
    static let ypBlue = UIColor(hex: 0x3772E7)
    static let ypSearchBarDay = UIColor(hex: 0x767680, alpha: 0.12)
    static let ypBlackDayTint = UIColor(hex: 0x1A1B22,alpha: 0.3)
    
    // MARK: - Life cicle
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
