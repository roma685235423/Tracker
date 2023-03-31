import UIKit

final class NewTrackerConstructor: UIInputViewController {
    // MARK: - UIElements
    private let screenTopLabel = UILabel()
    private let textField = MyTextField()
    
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = InterfaceColors.whiteDay
        textField.delegate = self
        screenTopLabel.configureLabel(
            text: "Новая привычка",
            addToView: view,
            ofSize: 16,
            weight: .medium)
        configutetextField()
        setConstraints()
    }
    
    // MARK: - Methods
    private func setConstraints() {
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configutetextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.backgroundColor = InterfaceColors.backgruondDay
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [
                NSAttributedString.Key.foregroundColor: InterfaceColors.gray,
            ]
        )
    }
}


extension NewTrackerConstructor: UITextFieldDelegate {
    
}
