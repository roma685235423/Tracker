import UIKit

final class StatisticViewController: UIViewController {
    private let statisticLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView()
    private var currentDate = Date.from(date: Date())!
    
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
        configureLayout()
        configureMainSpacePlaceholderStack()
        print("\n\n✅\n\(Calendar.current.component(.weekday, from: currentDate))")
    }
    
    private func configureMainSpacePlaceholderStack() {
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainSpacePlaceholderStack)
        mainSpacePlaceholderStack.contentMode = .scaleAspectFit
        mainSpacePlaceholderStack.layer.masksToBounds = true
        let imageView = UIImageView(image: UIImage(named: "statisticPlaceholder"))
        imageView.layer.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        let label = UILabel()
        label.textColor = InterfaceColors.blackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Анализировать пока нечего"
        label.textAlignment = .center
        mainSpacePlaceholderStack.addArrangedSubview(imageView)
        mainSpacePlaceholderStack.addArrangedSubview(label)
        mainSpacePlaceholderStack.axis = .vertical
        mainSpacePlaceholderStack.alignment = .center
        mainSpacePlaceholderStack.spacing = 8
        
        NSLayoutConstraint.activate([
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureLayout() {
        statisticLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statisticLabel)
        
        NSLayoutConstraint.activate([
            statisticLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            statisticLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083)
        ])
    }
}
