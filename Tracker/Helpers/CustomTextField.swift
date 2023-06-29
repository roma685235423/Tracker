import UIKit

class CustomTextField: UITextField {
    // MARK: - Private properties
    private let leftInset: CGFloat = 16
    private let rightInset: CGFloat = 46
    private let topInset: CGFloat = 27
    private let bottomInset: CGFloat = 26
    
    // MARK: - Public methods
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
}
