import UIKit


class TrackersViewController: UIViewController, CreateTrackerDelegate {
    
    // MARK: - Properties
    private var currentDate: Date = Date()
    private let trackerLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView()
    private let searchSpacePlaceholderStack = UIStackView()
    
    private var visibleCategories: [TrackerCategory] = [] {
        didSet {
            checkPlaceholderVisabilityAfterSearch()
        }
    }
    private var categories: [TrackerCategory] = mockData {
        didSet {
            checkMainPlaceholderVisability()
        }
    }
    
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
        picker.maximumDate = Date()
        
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
        mainSpacePlaceholderStack.configurePlaceholderStack(imageName: "starPlaceholder", text: "Что будем отслеживать?")
        searchSpacePlaceholderStack.configurePlaceholderStack(imageName: "searchPlaceholder", text: "Ничего не найдено")
        checkMainPlaceholderVisability()
    }
    
    
    // MARK: - Methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = Date().getDate()
        collectionView.reloadData()
    }
    
    
    private func configureLayout() {
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersSearchBar.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        searchSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackerLabel)
        view.addSubview(addTrackerButton)
        view.addSubview(trackersSearchBar)
        view.addSubview(datePicker)
        view.addSubview(collectionView)
        view.addSubview(mainSpacePlaceholderStack)
        view.addSubview(searchSpacePlaceholderStack)
        
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
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            searchSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    private func checkMainPlaceholderVisability() {
        let isHidden = categories.isEmpty
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    private func checkPlaceholderVisabilityAfterSearch() {
        let isHidden = visibleCategories.isEmpty && mainSpacePlaceholderStack.isHidden
        searchSpacePlaceholderStack.isHidden = !isHidden
    }
    
    
    @objc
    private func didTapAddTrackerButton() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.modalPresentationStyle = .pageSheet
        createTrackerViewController.delegate = self
        createTrackerViewController.trackersVCDismissCallbeck = { [weak self] in
            self?.dismiss(animated: true)
        }
        createTrackerViewController.trackersVCCreateCallbeck = { [weak self] categoryLabel, tracker in
            self?.dismiss(animated: true)
            self?.updateCategory(categoryLabel: categoryLabel, tracker: tracker)
        }
        present(createTrackerViewController, animated: true)
    }
    
    
    func getTrackersCategories() -> [String] {
        let trackersCategories = categories.map {$0.title}
        return trackersCategories
    }
    
    private func updateCategory(categoryLabel: String, tracker: Tracker) {
        guard let categoryIndex = categories.firstIndex(where: { $0.title == categoryLabel }) else { return }
        let updatedCategory = TrackerCategory(
            title: categoryLabel,
            trackers: categories[categoryIndex].trackers + [tracker]
        )
        categories[categoryIndex] = updatedCategory
        collectionView.reloadData()
    }
}



//MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            visibleCategories = categories
        } else {
            visibleCategories = categories.compactMap { category in
                let visibleTrackers = category.trackers.filter { tracker in
                    let words = tracker.label.split(separator: " ").map { String($0) }
                    return words.contains { word in
                        word.lowercased().hasPrefix(searchText.lowercased())
                    }
                }
                return visibleTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: visibleTrackers)
            }
        }
        collectionView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        visibleCategories = categories
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
}



//MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
}



//MARK: - UICollectionViewDataSource
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
        cell.configureCellContent(prototype: tracker, daysCounter: 7, isDone: true)
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
