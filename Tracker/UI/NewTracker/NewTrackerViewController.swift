import UIKit



protocol CreateTrackerViewControllerDelegate: AnyObject {
    func openTrackerConstructorWith(regularEvent: Bool)
}



final class NewTrackerViewController: UIViewController {
    // MARK: - UIElements
    private let goToCreateHabitScreenButton = UIButton(label: "Привычка")
    private let goToCreateIrregularEventScreenButton = UIButton(label: "Нерегулярные событие")
    
    weak var deligate: CreateTrackerViewControllerDelegate?
    
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentConfiguration()
        configureLayout()
        navigationControllerConfiguration()
    }
    
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        goToCreateHabitScreenButton.addToSuperview(view)
        goToCreateIrregularEventScreenButton.addToSuperview(view)
        
        NSLayoutConstraint.activate([
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
    
    // MARK: - Methods
    private func navigationControllerConfiguration() {
        title = "Создание трекера"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: InterfaceColors.blackDay
        ]
    }
    
    private func contentConfiguration() {
        view.backgroundColor = InterfaceColors.whiteDay
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
    
    
    // MARK: - Actions
    @objc
    private func didTapGoToCreateHabitScreenButton() {
        let newTrackerConstructorView = NewTrackerConstructorVC(isRegularEvent: true)
        navigationController?.pushViewController(newTrackerConstructorView, animated: true)
//        deligate?.openTrackerConstructorWith(regularEvent: true)
    }
    
    
    @objc
    private func didTapGoToCreateIrregularEventScreenButton() {
        let newTrackerConstructorView = NewTrackerConstructorVC(isRegularEvent: false)
        navigationController?.pushViewController(newTrackerConstructorView, animated: true)
//        deligate?.openTrackerConstructorWith(regularEvent: false)
    }
}
