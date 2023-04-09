import UIKit


class TrackersViewController: UIViewController & CreateTrackerDelegate {
    // MARK: - Properties
    private var currentDate: Date = Date()
    private let trackerLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView()
    
    private var visibleCategories: [TrackerCategory] = []
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Важное", trackers: []),
        TrackerCategory(title: "Swift", trackers: [
            Tracker(id: UUID.init(), label: "Учить Swift", color: .green, emoji: "🗿", dailySchedule: []),
            Tracker(id: UUID.init(), label: "жедневно учить Swift", color: .magenta, emoji: "🐺", dailySchedule: [])]
                        ),
        TrackerCategory(title: "Дом", trackers: [])
    ]
    
    
    lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = InterfaceColors.blackDay
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddTrackerButton), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var trackersSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.layer.masksToBounds = true
        bar.searchBarStyle = .minimal
        bar.placeholder = "Поиск"
        bar.delegate = self
        return bar
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        //collection.dataSource = self
        collection.delegate = self
        collection.register(TrackersCollectinCell.self, forCellWithReuseIdentifier: "trackersCollectionCell")
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.backgroundColor = InterfaceColors.whiteDay
        collection.isScrollEnabled = false
        collection.allowsMultipleSelection = false
        return collection
    }()

    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        
        picker.tintColor = InterfaceColors.blue
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        return picker
    }()
    
    
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
        configureLayout()
        configureMainSpacePlaceholderStack()
    }
    
    
    // MARK: - Methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
            currentDate = Date.from(date: sender.date)!
            collectionView.reloadData()
    }
    
    
    private func configureMainSpacePlaceholderStack() {
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
    }
    
    
    private func configureLayout() {
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersSearchBar.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackerLabel)
        view.addSubview(addTrackerButton)
        view.addSubview(trackersSearchBar)
        view.addSubview(mainSpacePlaceholderStack)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083),
            trackerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: trackerLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addTrackerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.07019),
            
            trackersSearchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            trackersSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            trackersSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            trackersSearchBar.heightAnchor.constraint(equalToConstant: 36),
            
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc
    private func didTapAddTrackerButton() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .pageSheet
        createTrackerViewController.delegate = self
        createTrackerViewController.trackersVCDismissCallbeck = { [weak self] in
            self?.dismiss(animated: true)
        }
        present(createTrackerViewController, animated: true)
    }
    
    
    func getTrackersCategories() -> [String] {
        let trackersCategories = categories.map {$0.title}
        return trackersCategories
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self.searchText = searchText
        collectionView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        //self.searchText = ""
        collectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

//extension TrackersViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
