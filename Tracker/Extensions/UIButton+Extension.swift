import UIKit

extension UIButton {
    convenience init(label: String, size: CGFloat = 16, cornerRadius: CGFloat = 16) {
        self.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = InterfaceColors.blackDay
        self.setTitle(label, for: .normal)
        self.setTitleColor(InterfaceColors.whiteDay, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .medium)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func addToSuperview(_ superview: UIView) {
        superview.addSubview(self)
    }
    
    func isButtonActive(isActive: Bool) {
        self.isEnabled = isActive
        let backgroundColor = isActive ? InterfaceColors.blackDay : InterfaceColors.gray
        self.backgroundColor = backgroundColor
    }
}
