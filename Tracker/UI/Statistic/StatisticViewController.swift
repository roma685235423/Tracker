import UIKit

final class StatisticViewController: UIViewController {
    // MARK: - Public properties
    var statisticsViewModel: StatisticsViewModel?
    
    // MARK: - Private properties
    private let statisticLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView(
        imageName: "statisticPlaceholder",
        text: NSLocalizedString("statistics.mainPlaceholder", comment: "")
    )
    private let statisticsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    private let trackersCompletedView = StatisticsView(
        name: NSLocalizedString("statistics.trackersCompleted", comment: "")
    )
    private var currentDate = Date.getDate(Date())
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        statisticLabel.configureLabel(
            text: NSLocalizedString("statistics.title", comment: ""),
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        configureLayout()
        statisticsViewModel?.statisticVCCallback = { [weak self] trackers in
            guard let self else { return }
            self.trackersCompletedView.setNumber(trackers.count)
            self.trackersCompletedView(isVisible: !trackers.isEmpty)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticsViewModel?.viewWillAppear()
    }
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        statisticLabel.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statisticLabel)
        view.addSubview(mainSpacePlaceholderStack)
        view.addSubview(statisticsStack)
        statisticsStack.addArrangedSubview(trackersCompletedView)
        
        NSLayoutConstraint.activate([
            statisticLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            statisticLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083),
            
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statisticsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupCompletedTrackersBlock(with count: Int) {
        trackersCompletedView.setNumber(count)
    }
    
    private func trackersCompletedView(isVisible: Bool) {
        if isVisible {
            mainSpacePlaceholderStack.isHidden = true
            statisticsStack.isHidden = false
        } else {
            mainSpacePlaceholderStack.isHidden = false
            statisticsStack.isHidden = true
        }
    }
}
