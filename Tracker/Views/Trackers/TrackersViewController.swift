import UIKit


class TrackersViewController: UIViewController & CreateTrackerDelegate {
    // MARK: - Properties
    private var currentDate: Date = Date()
    private let trackerLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView()
    
    private var visibleCategories: [TrackerCategory] = [] {
        didSet {
            checkPlaceholderVisability()
        }
    }
    private var categories: [TrackerCategory] = mockData
    
    private var trackerCollectionViewParaneters = CollectionParameters(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    
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
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(TrackersCollectinCell.self, forCellWithReuseIdentifier: "trackersCollectionCell")
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collection.backgroundColor = InterfaceColors.whiteDay
        //        collection.isScrollEnabled = false
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
        visibleCategories = categories
        trackerLabel.configureLabel(
            text: "Трекеры",
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        configureLayout()
        configureMainSpacePlaceholderStack()
        checkPlaceholderVisability()
    }
    
    
    // MARK: - Methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = Date().getDate()
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackerLabel)
        view.addSubview(addTrackerButton)
        view.addSubview(trackersSearchBar)
        view.addSubview(mainSpacePlaceholderStack)
        view.addSubview(datePicker)
        view.addSubview(collectionView)
        
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
            
            collectionView.topAnchor.constraint(equalTo: trackersSearchBar.bottomAnchor, constant: 34),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    private func checkPlaceholderVisability() {
        let isHidden = visibleCategories.isEmpty ? true : false
        mainSpacePlaceholderStack.isHidden = isHidden
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

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackersCollectionCell", for: indexPath)
                as? TrackersCollectinCell else { fatalError("Invalid TrackerCollectionView cell configuration !!!") }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.configureCellContent(prototype: tracker)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? SupplementaryView
        else { return UICollectionReusableView() }
        
        view.titleLabel.text = visibleCategories[indexPath.section].title
        return view
    }
}



//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableSize = collectionView.frame.width - trackerCollectionViewParaneters.paddingWidth
        let cellWidth = availableSize / CGFloat(trackerCollectionViewParaneters.cellCount)
        return CGSize(width: cellWidth, height: 150)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: trackerCollectionViewParaneters.leftInset, bottom: 16, right: trackerCollectionViewParaneters.rightInset)
    }
}
