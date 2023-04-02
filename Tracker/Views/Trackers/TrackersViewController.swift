import UIKit

class TrackersViewController: UIViewController {
    
    lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 19,
                weight: .bold
            )
        )
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = InterfaceColors.blackDay
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddTrackerButton), for: .touchUpInside)
        return button
    }()
    
    private let trackerLabel = UILabel()
    private let trackersSearchBar = UISearchTextField()
    private let mainSpacePlaceholderStack = UIStackView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = InterfaceColors.whiteDay
        trackerLabel.configureLabel(
            text: "Трекеры",
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        setConstraintsForElements()
        configureTrackersSearchBar()
        configureMainSpacePlaceholderStack()
    }
    
    
    // MARK: - Methods
    private func configureMainSpacePlaceholderStack() {
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainSpacePlaceholderStack)
        mainSpacePlaceholderStack.contentMode = .scaleAspectFit
        mainSpacePlaceholderStack.layer.masksToBounds = true
        let imageView = UIImageView(image: UIImage(named: "starPlaceholder"))
        imageView.layer.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        let label = UILabel()
        label.textColor = InterfaceColors.blackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        mainSpacePlaceholderStack.addArrangedSubview(imageView)
        mainSpacePlaceholderStack.addArrangedSubview(label)
        mainSpacePlaceholderStack.axis = .vertical
        mainSpacePlaceholderStack.alignment = .center
        mainSpacePlaceholderStack.spacing = 8
        
        NSLayoutConstraint.activate([
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: trackersSearchBar.bottomAnchor, constant: 230),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureTrackersSearchBar() {
        trackersSearchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersSearchBar)
        trackersSearchBar.contentMode = .scaleAspectFit
        trackersSearchBar.layer.masksToBounds = true
        trackersSearchBar.clearButtonMode = .whileEditing
        trackersSearchBar.keyboardType = .default
        trackersSearchBar.attributedPlaceholder = NSAttributedString(
            string: "Поиск",
            attributes: [
                NSAttributedString.Key.foregroundColor: InterfaceColors.gray,
            ]
        )
        
        NSLayoutConstraint.activate([
            trackersSearchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            trackersSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            trackersSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            trackersSearchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    private func setConstraintsForElements() {
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackerLabel)
        view.addSubview(addTrackerButton)
        
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            trackerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            
            addTrackerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            addTrackerButton.bottomAnchor.constraint(equalTo: trackerLabel.topAnchor, constant: -5),
        ])
    }
    
    @objc
    private func didTapAddTrackerButton() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .pageSheet
        present(createTrackerViewController, animated: true)
    }
}

extension TrackersViewController: UISearchBarDelegate {
    
}
