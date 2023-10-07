import UIKit

extension UILabel {
    
    // MARK: Puplic methods
    
    func configureLabel(text: String, addToView: UIView, ofSize: CGFloat, weight: UIFont.Weight) {
        self.translatesAutoresizingMaskIntoConstraints = false
        addToView.addSubview(self)
        self.text = text
        self.font = UIFont.systemFont(ofSize: ofSize, weight: weight)
        self.textAlignment = .center
        self.textColor = .ypBlack
    }
}
