import UIKit

final class OnboardingViewController: UIViewController {
    // MARK: - Private properties
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let page: OnboardingPage
    
    // MARK: - Life cicle
    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContent(for: page)
        addingUIElements()
        layoutConfigure()
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        view.addSubview(imageView)
        imageView.addSubview(textLabel)
    }
    
    private func layoutConfigure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
        ])
    }
    
    private func configureContent(for page: OnboardingPage) {
        let text: String
        switch page {
        case .first:
            text = NSLocalizedString("firstOnboarding.text", comment: "")
            imageView.image = UIImage(named: "back1")
        case .second:
            text = NSLocalizedString("secondOnboarding.text", comment: "")
            imageView.image = UIImage(named: "back2")
        }
        textLabel.configureLabel(
            text: text,
            addToView: view,
            ofSize: 32,
            weight: .bold
        )
        
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.textColor = .ypBlackDay
    }
}


enum OnboardingPage: CaseIterable {
    case first
    case second
}
