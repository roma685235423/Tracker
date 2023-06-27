import UIKit

final class NewTrackerViewController: UIViewController {
    // MARK: - UIElements
    private let goToCreateHabitScreenButton = UIButton(label: "Привычка")
    private let goToCreateIrregularEventScreenButton = UIButton(label: "Нерегулярные событие")
    
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
        view.backgroundColor = .ypWhiteDay
        addingUIElements()
        configurenavigationController()
        configureButtons()
        layoutConfigure()
    }
    
    // MARK: - Layout configuraion
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
    
    // MARK: - Layout configuraion
    private func addingUIElements() {
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(goToCreateHabitScreenButton)
        buttonsStackView.addArrangedSubview(goToCreateIrregularEventScreenButton)
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            goToCreateHabitScreenButton.heightAnchor.constraint(equalToConstant: 60),
            goToCreateIrregularEventScreenButton.heightAnchor.constraint(equalTo: goToCreateHabitScreenButton.heightAnchor)
        ])
    }
    
    private func configurenavigationController() {
        title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlackDay
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
