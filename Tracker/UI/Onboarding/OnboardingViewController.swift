import UIKit


final class OnboardingViewController: UIViewController {
    // MARK: - Properties
    private let page: OnboardingPage
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutConfigure()
        configureContent(for: page)
    }
    
    
    // MARK: - Сontent configuraion
    private func configureContent(for page: OnboardingPage) {
        let text: String
        switch page {
        case .first:
            text = "Отслеживайте только то, что хотите"
            imageView.image = UIImage(named: "onboarding1")
        case .second:
            text = "Даже если это не литры воды и йога"
            imageView.image = UIImage(named: "onboarding2")
        }
        textLabel.configureLabel(
            text: text,
            addToView: view,
            ofSize: 32,
            weight: .bold
        )
        
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
    }
    
    
    // MARK: - Layout configuraion
    private func layoutConfigure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        imageView.addSubview(textLabel)
        
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
    
    
    // MARK: - Init
    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



enum OnboardingPage: CaseIterable {
    case first
    case second
}
