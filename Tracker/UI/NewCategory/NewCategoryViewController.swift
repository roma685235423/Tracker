import UIKit

final class NewCategoryViewController: UIViewController {
    // MARK: - Properties
    private let textField = CustomTextField(with: NSLocalizedString(
        "newCategory.categoryName",
        comment: ""
    ))
    private let screenTopLabel = UILabel()
    private let createNewCategoryButton = UIButton(
        label:
            NSLocalizedString(
                "newCategory.ready",
                comment: ""
            ))
    
    private let viewModel: CategorySelectionViewModel
    private var newCategoryName: String = ""
    
    // MARK: - Lifecicle
    init(viewModel: CategorySelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        screenTopLabel.configureLabel(
            text: NSLocalizedString("newCategory.categoryName", comment: ""),
            addToView: view,
            ofSize: 16,
            weight: .medium)
        addingUIElements()
        createNewCategoryButton.addTarget(
            self,
            action: #selector(didTapCreateNewCategoryButton),
            for: .touchUpInside
        )
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
        textField.text = newCategoryName
        textField.addTarget(self, action: #selector(checkIsCreateButtonActive), for: .editingChanged)
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
        if let text = textField.text, !text.isEmpty {
            newCategoryName = text
            createNewCategoryButton.isButtonActive(isActive: true)
        } else {
            createNewCategoryButton.isButtonActive(isActive: false)
        }
    }
    
    @objc
    private func didTapCreateNewCategoryButton() {
        let newCategory = TrackerCategory(title: newCategoryName)
        viewModel.add(newCategory: newCategory)
        dismiss(animated: true)
    }
}


// MARK: - UITextFieldDelegate Extension
extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
