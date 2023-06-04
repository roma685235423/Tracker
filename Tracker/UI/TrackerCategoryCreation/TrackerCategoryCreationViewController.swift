import UIKit

final class TrackerCategoryCreationViewController: UIViewController {
    // MARK: - UIElements
    private let textField = CustomTextField()
    private let screenTopLabel = UILabel()
    private let createNewCategoryButton = UIButton(label: "Готово")
    
    private var newCategoryName: String = ""
    
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = InterfaceColors.whiteDay
        screenTopLabel.configureLabel(
            text: "Новая категория",
            addToView: view,
            ofSize: 16,
            weight: .medium)
        createNewCategoryButton.addTarget(self, action: #selector(didTapCreateNewCategoryButton), for: .touchUpInside)
        configureLayout()
        checkIsCreateButtonActive()
        configureTextField()
    }
    
    
    
    private func configureLayout() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        screenTopLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        view.addSubview(screenTopLabel)
        createNewCategoryButton.addToSuperview(view)
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            createNewCategoryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            createNewCategoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            createNewCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createNewCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    
    private func configureTextField() {
        textField.delegate = self
        textField.backgroundColor = InterfaceColors.backgruondDay
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название категории",
            attributes: [
                NSAttributedString.Key.foregroundColor: InterfaceColors.gray,
            ]
        )
    }
    
    
    @objc
    private func checkIsCreateButtonActive() {
        if self.newCategoryName != "" {
            createNewCategoryButton.isButtonActive(isActive: true)
        } else {
            createNewCategoryButton.isButtonActive(isActive: false)
        }
    }
    
    
    @objc
    private func didTapCreateNewCategoryButton() {
        dismiss(animated: true)
    }
}



// MARK: - UITextFieldDelegate Extension
extension TrackerCategoryCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newCategoryName = textField.text ?? ""
        textField.resignFirstResponder()
        checkIsCreateButtonActive()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        newCategoryName = textField.text ?? ""
        checkIsCreateButtonActive()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        newCategoryName = textField.text ?? ""
        checkIsCreateButtonActive()
        return true
    }
}
