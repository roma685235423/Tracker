import UIKit

final class StatisticViewController: UIViewController {
    private let statisticLabel = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = InterfaceColors.whiteDay
        statisticLabel.configureLabel(
            text: "Статистика",
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        setConstraintsForElements()
    }
    
    private func setConstraintsForElements() {
        statisticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statisticLabel)
        
        NSLayoutConstraint.activate([
            statisticLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            statisticLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
        ])
    }
}
