import UIKit

final class TabBarViewController: UITabBarController {
    
    private let border = UIView()
    private func configureBorder() {
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        border.backgroundColor = InterfaceColors.gray
        
        NSLayoutConstraint.activate([
            border.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            border.widthAnchor.constraint(equalTo: view.widthAnchor),
            border.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureBorder()
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
