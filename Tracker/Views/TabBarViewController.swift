import UIKit

final class TabBarViewController: UITabBarController {
    
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
        
        self.viewControllers = [trackerViewController, statisticViewController]
    }
}
