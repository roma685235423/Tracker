import UIKit

final class NewCategoryViewController: UIViewController {
    // MARK: - Properties
    private let textField = CustomTextField(with: NSLocalizedString("newCategory.categoryName", comment: ""))
    private let screenTopLabel = UILabel()
    private let createNewCategoryButton = UIButton(
        label:
            NSLocalizedString(
                "newCategory.ready",
                comment: ""
            )
    )
    
    private var newCategoryName: String = ""
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        screenTopLabel.configureLabel(
            text: NSLocalizedString("newCategory.categoryName", comment: ""),
            addToView: view,
            ofSize: 16,
            weight: .medium)
        addingUIElements()
        createNewCategoryButton.addTarget(self, action: #selector(didTapCreateNewCategoryButton), for: .touchUpInside)
        checkIsCreateButtonActive()
        configureTextField()
        layoutConfigure()
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        view.addSubview(textField)
        view.addSubview(screenTopLabel)
        createNewCategoryButton.addToSuperview(view)
    }
    
    private func layoutConfigure() {
        screenTopLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.keyboardType = .default
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("newCategory.categoryName", comment: ""),
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.ypGray,
            ]
        )
    }
    
    // MARK: - Actions
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
extension NewCategoryViewController: UITextFieldDelegate {
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
