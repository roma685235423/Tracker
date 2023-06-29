import UIKit

final class StatisticViewController: UIViewController {
    // MARK: - Private properties
    private let statisticLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView(
        imageName: "statisticPlaceholder",
        text: "Анализировать пока нечего"
    )
    
    private var currentDate = Date.getDate(Date())
    
    // MARK: - Life cicle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = .ypWhiteDay
        statisticLabel.configureLabel(
            text: "Статистика",
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        configureLayout()
    }
    
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        statisticLabel.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statisticLabel)
        view.addSubview(mainSpacePlaceholderStack)
        
        NSLayoutConstraint.activate([
            statisticLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            statisticLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083),
            
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
