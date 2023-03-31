import UIKit

final class StatisticViewController: UIViewController {
    
    lazy var statisticLabel: UILabel = {
        let label = UILabel()
        label.text = "Статистика"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = InterfaceColors.blackDay
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = InterfaceColors.whiteDay
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
