import UIKit

class MyTextField: UITextField {
    let leftInset: CGFloat = 16
    let rightInset: CGFloat = 46
    let topInset: CGFloat = 27
    let bottomInset: CGFloat = 26
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
