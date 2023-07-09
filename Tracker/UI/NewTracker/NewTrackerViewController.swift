import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: - Private properties
    private let goToCreateHabitScreenButton = UIButton(
        label: NSLocalizedString(
            "newTracker.habitButton",
            comment: ""
        )
    )
    private let goToCreateIrregularEventScreenButton = UIButton(
        label: NSLocalizedString(
            "newTracker.eventButton",
            comment: ""
        )
    )
    private let buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configurenavigationController()
        configureStackView()
        configureButtons()
        
    }
    
    // MARK: - Private methods
    private func configureButtons() {
        goToCreateHabitScreenButton.addTarget(
            self,
            action: #selector(didTapGoToCreateHabitScreenButton),
            for: .touchUpInside
        )
        goToCreateIrregularEventScreenButton.addTarget(
            self,
            action: #selector(didTapGoToCreateIrregularEventScreenButton),
            for: .touchUpInside
        )
    }
    
    private func configureStackView() {
        view.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(goToCreateHabitScreenButton)
        buttonsStackView.addArrangedSubview(goToCreateIrregularEventScreenButton)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            goToCreateHabitScreenButton.heightAnchor.constraint(equalToConstant: 60),
            goToCreateIrregularEventScreenButton.heightAnchor.constraint(equalTo: goToCreateHabitScreenButton.heightAnchor)
        ])
    }
    
    private func configurenavigationController() {
        title = NSLocalizedString("newTracker.title", comment: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlack
        ]
    }
    
    // MARK: - Actions
    @objc
    private func didTapGoToCreateHabitScreenButton() {
        let newTrackerConstructorView = ConstructorViewController(isRegularEvent: true)
        navigationController?.pushViewController(newTrackerConstructorView, animated: true)
    }
    
    @objc
    private func didTapGoToCreateIrregularEventScreenButton() {
        let newTrackerConstructorView = ConstructorViewController(isRegularEvent: false)
        navigationController?.pushViewController(newTrackerConstructorView, animated: true)
    }
}
