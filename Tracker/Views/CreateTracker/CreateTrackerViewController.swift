import UIKit

final class CreateTrackerViewController: UIViewController {
    // MARK: - UIElements
    private let screenTopLabel = UILabel()
    private let goToCreateHabitScreenButton = UIButton()
    private let goToCreateIrregularEventScreenButton = UIButton()
    
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = InterfaceColors.whiteDay
        screenTopLabel.configureLabel(
            text: "Создание трекера",
            addToView: view,
            ofSize: 16,
            weight: .medium)
        configureButton(
            button: goToCreateHabitScreenButton,
            text: "Привычка",
            action: #selector(didTapGoToCreateHabitScreenButton)
        )
        configureButton(
            button: goToCreateIrregularEventScreenButton,
            text: "Нерегулярные событие",
            action: #selector(didTapGoToCreateIrregularEventScreenButton)
        )
        setConstraints()
    }
    
    // MARK: - Methods
    private func configureButton(button: UIButton, text: String, action: Selector) {
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.backgroundColor = InterfaceColors.blackDay
        button.setTitle(text, for: .normal)
        button.titleLabel?.textColor = InterfaceColors.whiteDay
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            goToCreateHabitScreenButton.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 295),
            goToCreateHabitScreenButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            goToCreateHabitScreenButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            goToCreateHabitScreenButton.heightAnchor.constraint(equalToConstant: 60),
            
            goToCreateIrregularEventScreenButton.topAnchor.constraint(equalTo: goToCreateHabitScreenButton.bottomAnchor, constant: 16),
            goToCreateIrregularEventScreenButton.leftAnchor.constraint(equalTo: goToCreateHabitScreenButton.leftAnchor),
            goToCreateIrregularEventScreenButton.rightAnchor.constraint(equalTo: goToCreateHabitScreenButton.rightAnchor),
            goToCreateIrregularEventScreenButton.heightAnchor.constraint(equalTo: goToCreateHabitScreenButton.heightAnchor)
        ])
    }
    
    @objc
    private func didTapGoToCreateHabitScreenButton() {
        let newTrackerConstructor = NewTrackerConstructor()
        newTrackerConstructor.modalPresentationStyle = .pageSheet
        present(newTrackerConstructor, animated: true)
    }
    
    @objc
    private func didTapGoToCreateIrregularEventScreenButton() {
    }
}
