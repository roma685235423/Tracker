import UIKit

class TrackersViewController: UIViewController {
    // MARK: - Private properties
    private let trackerLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView(
        imageName: "starPlaceholder",
        text: "Что будем отслеживать?"
    )
    private let searchSpacePlaceholderStack = UIStackView(
        imageName: "searchPlaceholder",
        text: "Ничего не найдено"
    )
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plus")
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .ypBlackDay
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
        collection.register(TrackersCollectionCell.self, forCellWithReuseIdentifier: "trackersCollectionCell")
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.backgroundColor = .ypWhiteDay
        collection.isScrollEnabled = true
        collection.allowsMultipleSelection = false
        return collection
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        picker.maximumDate = Date()
        picker.tintColor = .ypBlue
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        picker.addTarget(self, action: #selector(didChangedDatePickerValue), for: .valueChanged)
        return picker
    }()
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private var currentDate: Date = Date().getDate()!
    private var complitedTrackers: Set<TrackerRecord> = []
    private var searchedText = "" {
        didSet{
            try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchedText)
            try? trackerRecordStore.completedTrackers(by: currentDate)
        }
    }
    private var trackerCollectionViewParameters = CollectionParameters(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    // MARK: - Life cicle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = .ypWhiteDay
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        trackerLabel.configureLabel(
            text: "Трекеры",
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        addingUIElements()
        layoutConfigure()
        try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchedText)
        try? trackerRecordStore.completedTrackers(by: currentDate)
        checkMainPlaceholderVisability()
        checkPlaceholderVisabilityAfterSearch()
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        [addTrackerButton, trackerLabel, trackersSearchBar, datePicker,
         collectionView, mainSpacePlaceholderStack, searchSpacePlaceholderStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083),
            trackerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            datePicker.centerYAnchor.constraint(equalTo: trackerLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addTrackerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.07019),
            
            trackersSearchBar.topAnchor.constraint(equalTo: trackerLabel.bottomAnchor, constant: 7),
            trackersSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            trackersSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            trackersSearchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: trackersSearchBar.bottomAnchor, constant: 34),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            searchSpacePlaceholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.495),
            searchSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func checkMainPlaceholderVisability() {
        let isHidden = trackerStore.numberOfTrackers == 0 && searchSpacePlaceholderStack.isHidden
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    private func checkPlaceholderVisabilityAfterSearch() {
        let isHidden = trackerStore.numberOfTrackers == 0 && searchedText != ""
        searchSpacePlaceholderStack.isHidden = !isHidden
    }
    
    // MARK: - Actions
    @objc
    private func didChangedDatePickerValue(_ sender: UIDatePicker) {
        currentDate = sender.date.getDate()!
        do {
            try trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchedText)
            try trackerRecordStore.completedTrackers(by: currentDate)
        } catch {}
        collectionView.reloadData()
    }
    
    
    @objc
    private func didTapAddTrackerButton() {
        let createTrackerViewController = NewTrackerViewController()
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true)
    }
}


//MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        checkPlaceholderVisabilityAfterSearch()
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        checkPlaceholderVisabilityAfterSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchText
        collectionView.reloadData()
        checkPlaceholderVisabilityAfterSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedText = ""
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        collectionView.reloadData()
        checkPlaceholderVisabilityAfterSearch()
    }
}


//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        checkMainPlaceholderVisability()
        return trackerStore.numberOfSections
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return trackerStore.getNumberOfRowsInSection(section: section)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "trackersCollectionCell",
            for: indexPath
        ) as? TrackersCollectionCell
        else { fatalError("Invalid TrackerCollectionView cell configuration !!!") }
        
        guard let tracker = trackerStore.getTrackerAt(indexPath: indexPath)
        else { fatalError("Invalid Tracker creation!!!") }
        
        let isDone = complitedTrackers.contains { $0.date == currentDate && $0.trackerId == tracker.id }
        let daysCounter = tracker.daysComplitedCount
        cell.configureCellContent(prototype: tracker, daysCounter: daysCounter, isDone: isDone)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView (
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? SupplementaryView
        else { return UICollectionReusableView() }
        view.configoreLayout(leftOffset: 28, topOffset: 15, bottomOffset: 15)
        view.titleLabel.text = trackerStore.getHeaderLabelFor(section: indexPath.section)
        return view
    }
}


// MARK: - TrackerCellDelegate
extension TrackersViewController: TrackersCollectinCellDelegate {
    func didTapTaskIsDoneButton(cell: TrackersCollectionCell, tracker: Tracker) {
        if let removedRecord = complitedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            try? trackerRecordStore.remove(record: removedRecord)
            cell.setTaskIsDoneButton(equalTo: false)
            cell.counterSub()
        } else {
            let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
            try? trackerRecordStore.add(record: trackerRecord)
            cell.setTaskIsDoneButton(equalTo: true)
            cell.counterAdd()
        }
    }
}


//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let availableSize = collectionView.frame.width - trackerCollectionViewParameters.paddingWidth
        let cellWidth = availableSize / CGFloat(trackerCollectionViewParameters.cellCount)
        
        return CGSize(width: cellWidth, height: 150)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return 9
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: trackerCollectionViewParameters.leftInset,
                            bottom: 16, right: trackerCollectionViewParameters.rightInset)
    }
}


// MARK: - TrackerStoreDelegate
extension TrackersViewController: TrackerStoreDelegate {
    func updateTrackers() {
        checkMainPlaceholderVisability()
        checkPlaceholderVisabilityAfterSearch()
        collectionView.reloadData()
    }
}


// MARK: - TrackerRecordStoreDelegate
extension TrackersViewController: TrackerRecordStoreDelegate {
    func didUpdate(records: Set<TrackerRecord>) {
        complitedTrackers = records
    }
}
