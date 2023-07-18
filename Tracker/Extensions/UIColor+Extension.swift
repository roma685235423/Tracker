import UIKit

extension UIColor {
    // MARK: - Public properties
    static let ypBlackDay = UIColor(hex: 0x1A1B21)
    static let ypBlackNight = UIColor(hex: 0xFFFFFF)
    static let ypWhiteDay = UIColor(hex: 0xFFFFFF)
    static let ypWhiteNight = UIColor(hex: 0x1A1B21)
    static let ypGray = UIColor(hex: 0xAEAFB4)
    static let ypLightGray = UIColor(hex: 0xE6E8EB)
    static let ypBackgroundDay = UIColor(hex: 0xE6E8EB, alpha: 0.3)
    static let ypBackgroundNight = UIColor(hex: 0x414141, alpha: 0.85)
    static let ypRed = UIColor(hex: 0xF56B6C)
    static let ypBlue = UIColor(hex: 0x3772E7)
    static let ypSearchBarDay = UIColor(hex: 0x767680, alpha: 0.12)
    static let ypBlackDayTint = UIColor(hex: 0x1A1B22,alpha: 0.3)
    static let ypDatePickerBackground = UIColor(hex: 0xF0F0F0)
    static let gradientColors = [
    UIColor(hex: 0x007BFA),
    UIColor(hex: 0x46E69D),
    UIColor(hex: 0xFD4C49)
    ]
    
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



extension UIColor {
    static var ypBlack: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                return traits.userInterfaceStyle == .dark ? .ypBlackNight : .ypBlackDay
            }
        } else {
            return .ypBlackDay
        }
    }
    
    static var ypWhite: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                return traits.userInterfaceStyle == .dark ? .ypWhiteNight : .ypWhiteDay
            }
        } else {
            return .ypWhiteDay
        }
    }
    
    static var ypBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                return traits.userInterfaceStyle == .dark ? .ypBackgroundNight : .ypBackgroundDay
            }
        } else {
            return .ypBackgroundDay
        }
    }
    
    static var ypTabBarBorder: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return UIColor(hex: 0x121318)
                } else {
                    return UIColor(hex: 0xB2B2B2)
                }
            }
        } else {
            return UIColor(hex: 0xB2B2B2)
        }
    }
    
    static var ypSwitchBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traits -> UIColor in
                if traits.userInterfaceStyle == .dark {
                    return UIColor(hex: 0xE6E8EA)
                } else {
                    return .ypLightGray
                }
            }
        } else {
            return .ypLightGray
        }
    }
}
