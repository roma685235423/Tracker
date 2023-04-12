import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - UIElements
    private let border = UIView()
    
    // MARK: - Properties
    private var tabBarHeight: CGFloat = 0
    
    
    // MARK: - Lifecicle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarHeight = tabBar.frame.height
        configureBorder()
    }
    
    
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
    
    
    // MARK: - Layout configuraion
    private func configureBorder() {
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        border.backgroundColor = InterfaceColors.gray
        
        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight),
            border.widthAnchor.constraint(equalTo: view.widthAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
