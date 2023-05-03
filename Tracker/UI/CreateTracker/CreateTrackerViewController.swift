import UIKit

protocol CreateTrackerDelegate: AnyObject {
    func getTrackersCategories() -> [String]
}

final class CreateTrackerViewController: UIViewController, NewRegularTrackerConstructorDelegate {
    // MARK: - UIElements
    private let screenTopLabel = UILabel()
    private let goToCreateHabitScreenButton = UIButton()
    private let goToCreateIrregularEventScreenButton = UIButton()
    
    
    weak var delegate: CreateTrackerDelegate?
    
    var trackersVCDismissCallback: (() -> Void)?
    var trackersVCCreateCallback: ((String, Tracker) -> Void)?
    
    
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
        configureLayout()
    }
    
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            goToCreateHabitScreenButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.431),
            goToCreateHabitScreenButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            goToCreateHabitScreenButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            goToCreateHabitScreenButton.heightAnchor.constraint(equalToConstant: 60),
            
            goToCreateIrregularEventScreenButton.topAnchor.constraint(equalTo: goToCreateHabitScreenButton.bottomAnchor, constant: 16),
            goToCreateIrregularEventScreenButton.leftAnchor.constraint(equalTo: goToCreateHabitScreenButton.leftAnchor),
            goToCreateIrregularEventScreenButton.rightAnchor.constraint(equalTo: goToCreateHabitScreenButton.rightAnchor),
            goToCreateIrregularEventScreenButton.heightAnchor.constraint(equalTo: goToCreateHabitScreenButton.heightAnchor)
        ])
    }
    
    
    // MARK: - UIConfiguration methods
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
    
    
    // MARK: - Methods
    func getTrackersCategories() -> [String] {
        if let categories = delegate?.getTrackersCategories() {
            return categories
        } else {
            return []
        }
    }
    
    
    // MARK: - Actions
    @objc
    private func didTapGoToCreateHabitScreenButton() {
        let newTrackerConstructorView = NewTrackerConstructorViewController(isRegularEvent: true)
        newTrackerConstructorView.modalPresentationStyle = .pageSheet
        newTrackerConstructorView.deleagte = self
        newTrackerConstructorView.trackersVCCreateCallback = { [ weak self ] categoryLabel, tracker in
            self?.trackersVCCreateCallback?(categoryLabel, tracker)
        }
        newTrackerConstructorView.trackersVCCancelCallback = { [ weak self ] in
            self?.trackersVCDismissCallback?()
        }
        present(newTrackerConstructorView, animated: true)
    }
    
    
    @objc
    private func didTapGoToCreateIrregularEventScreenButton() {
        let newIrregularEventView = NewTrackerConstructorViewController(isRegularEvent: false)
        newIrregularEventView.modalPresentationStyle = .pageSheet
        newIrregularEventView.deleagte = self
        newIrregularEventView.trackersVCCreateCallback = { [ weak self ] categoryLabel, tracker in
            self?.trackersVCCreateCallback?(categoryLabel, tracker)
        }
        newIrregularEventView.trackersVCCancelCallback = { [ weak self ] in
            self?.trackersVCDismissCallback?()
        }
        present(newIrregularEventView, animated: true)
    }
}
