import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - Private properties
    private let borderView = UIView()
    
    private var tabBarHeight: CGFloat = 0
    
    // MARK: - Lifecicle
    override func awakeFromNib() {
        super.awakeFromNib()
        let trackerViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        let statisticsViewModel = StatisticsViewModel()
        statisticViewController.statisticsViewModel = statisticsViewModel
        
        trackerViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers", comment: ""),
            image: UIImage(named: "circle"),
            selectedImage: nil)
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics", comment: ""),
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
        borderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(borderView)
        borderView.backgroundColor = .ypTabBarBorder
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight),
            borderView.widthAnchor.constraint(equalTo: view.widthAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
