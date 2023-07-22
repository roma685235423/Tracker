import UIKit

class CustomTextField: UITextField {
    // MARK: - Private properties
    private let leftInset: CGFloat = 16
    private let rightInset: CGFloat = 46
    private let topInset: CGFloat = 27
    private let bottomInset: CGFloat = 26
    
    //MARK: - Lifecycle
    init(with text: String) {
        super.init(frame: .zero)
        uiConfiguration(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        ))
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        ))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect
    {
        return bounds.inset(by: UIEdgeInsets(
            top: topInset,
            left: leftInset,
            bottom: bottomInset,
            right: rightInset
        ))
    }
    
    // MARK: - Private methods
    private func uiConfiguration(with text: String) {
        font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textColor = .ypBlack
        backgroundColor = .ypBackground
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypGray
        ]
        let attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
        self.attributedPlaceholder = attributedPlaceholder
        
        heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
