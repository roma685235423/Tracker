import UIKit

extension UIButton {
    // MARK: - Life cicle
    convenience init(label: String, size: CGFloat = 16, cornerRadius: CGFloat = 16) {
        self.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .ypBlack
        self.setTitle(label, for: .normal)
        self.setTitleColor(.ypWhite, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .medium)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    // MARK: - Public properties
    func addToSuperview(_ superview: UIView) {
        superview.addSubview(self)
    }
    
    func isButtonActive(isActive: Bool) {
        self.isEnabled = isActive
        let backgroundColor = isActive ? UIColor.ypBlack : UIColor.ypGray
        let textColor = isActive ?  UIColor.ypWhite : UIColor.ypWhiteDay
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
    func setStaticColors() {
        backgroundColor = .ypBlackDay
        setTitleColor(.ypWhiteDay, for: .normal)
    }
}
