import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - Private properties
    private let border = UIView()
    
    private var tabBarHeight: CGFloat = 0
    
    // MARK: - Lifecicle
    override func awakeFromNib() {
        super.awakeFromNib()
        let trackerViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "circle"),
            selectedImage: nil)
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "hare"),
            selectedImage: nil)
        
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = .greatestFiniteMagnitude
        self.viewControllers = [trackerViewController, statisticViewController]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarHeight = tabBar.frame.height
        borderConfigure()
    }
    
    // MARK: - Private properties
    private func borderConfigure() {
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        border.backgroundColor = .ypGray
        
        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight),
            border.widthAnchor.constraint(equalTo: view.widthAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
