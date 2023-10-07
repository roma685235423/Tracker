import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: Private properties
    
    private let trackerLabel = UILabel()
    private let mainSpacePlaceholderStack = UIStackView(
        imageName: "starPlaceholder",
        text: NSLocalizedString(
            "trackers.mainPlaceholder",
            comment: ""
        )
    )
    private let searchSpacePlaceholderStack = UIStackView(
        imageName: "searchPlaceholder",
        text: NSLocalizedString(
            "trackers.searchPlaceholder",
            comment: ""
        )
    )
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "plus")!,
            target: self,
            action: #selector(didTapAddTrackerButton)
        )
        button.tintColor = .ypBlack
        return button
    }()
    private lazy var trackersSearchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.layer.masksToBounds = true
        bar.searchBarStyle = .minimal
        bar.placeholder =  NSLocalizedString(
            "trackers.searchBarPlaceholder",
            comment: ""
        )
        bar.delegate = self
        return bar
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.dataSource = self
        collection.delegate = self
        collection.register(
            TrackersCollectionCell.self,
            forCellWithReuseIdentifier: TrackersCollectionCell.identifier
        )
        collection.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collection.backgroundColor = .clear
        collection.isScrollEnabled = true
        collection.allowsMultipleSelection = false
        return collection
    }()
    lazy var localizedDateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .ypDatePickerBackground
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        return label
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale.current
        picker.maximumDate = Date()
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        picker.addTarget(self, action: #selector(didChangedDatePickerValue), for: .valueChanged)
        return picker
    }()
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString(
            "filters",
            comment: ""
        ), for: .normal)
        button.tintColor = .ypWhiteDay
        button.backgroundColor = .ypBlue
        button.titleLabel?.font = UIFont.systemFont(
            ofSize: 17,
            weight: .medium
        )
        button.addTarget(
            self,
            action: #selector(didTapFiltersButton),
            for: .touchUpInside
        )
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private let trackerStore = TrackerStore()
    private let trackerRecordStore = TrackerRecordStore()
    private let analyticsService = AnalyticsService()
    
    private var currentDate: Date = Date().getDate()!
    private var complitedTrackers: Set<TrackerRecord> = []
    private var searchedText = "" {
        didSet{
            try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchedText)
            try? trackerRecordStore.completedTrackers(by: currentDate)
        }
    }
    private let trackerCollectionViewParameters = CollectionParameters(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9
    )
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = .ypWhite
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        trackerLabel.configureLabel(
            text: NSLocalizedString("trackers", comment: ""),
            addToView: view,
            ofSize: 34,
            weight: .bold
        )
        view.addSubviews([addTrackerButton, trackerLabel, trackersSearchBar, datePicker, localizedDateLabel, collectionView, mainSpacePlaceholderStack, searchSpacePlaceholderStack, filterButton])
        layoutConfigure()
        try? trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchedText)
        try? trackerRecordStore.completedTrackers(by: currentDate)
        
        localizedDateLabel.text = currentDate.getStringFromLocalizedDate()
        checkMainPlaceholderVisability()
        checkPlaceholderVisabilityAfterSearch()
        filterButton.layer.zPosition = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyticsService.report(event: "open", params: ["screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        analyticsService.report(event: "close", params: ["screen": "Main"])
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

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
            withReuseIdentifier: TrackersCollectionCell.identifier,
            for: indexPath
        ) as? TrackersCollectionCell else {
            fatalError("Invalid TrackerCollectionView cell configuration !!!")
        }
        
        guard let tracker = trackerStore.tracker(at: indexPath)
        else { fatalError("Invalid Tracker creation!!!") }
        
        let isDone = complitedTrackers.contains {
            $0.date == currentDate && $0.trackerId == tracker.id
        }
        
        let daysCounter = tracker.daysComplitedCount
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.configureCellContent(
            prototype: tracker,
            daysCounter: daysCounter,
            isDone: isDone,
            isPinned: tracker.isPinned,
            userInteraction: interaction
        )
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
        view.titleLabel.text = trackerStore.getLabelFor(section: indexPath.section)
        view.titleLabel.textColor = .ypBlack
        return view
    }
}

// MARK: - TrackersCollectinCellDelegate

extension TrackersViewController: TrackersCollectinCellDelegate {
    
    func didTapTaskIsDoneButton(cell: TrackersCollectionCell, tracker: Tracker) {
        if let removedRecord = complitedTrackers.first(where: { $0.date == currentDate && $0.trackerId == tracker.id }) {
            try? trackerRecordStore.remove(record: removedRecord)
            cell.setTaskIsDoneButton(state: false)
            cell.counterSub()
        } else {
            let trackerRecord = TrackerRecord(trackerId: tracker.id, date: currentDate)
            try? trackerRecordStore.add(record: trackerRecord)
            cell.setTaskIsDoneButton(state: true)
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
        return UIEdgeInsets(
            top: 8,
            left: trackerCollectionViewParameters.leftInset,
            bottom: 16,
            right: trackerCollectionViewParameters.rightInset
        )
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension TrackersViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard
            let location = interaction.view?.convert(location, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: location),
            let tracker = trackerStore.tracker(at: indexPath),
            let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionCell
        else { return nil }
        
        var isPinnedTitle = ""
        if tracker.isPinned {
            isPinnedTitle = NSLocalizedString("trackers.unpinTracker", comment: "")
        } else {
            isPinnedTitle = NSLocalizedString("trackers.pinTracker", comment: "")
        }
        
        return UIContextMenuConfiguration(actionProvider:  { actions in
            UIMenu(children: [
                UIAction(title: isPinnedTitle) { [weak self] _ in
                    guard let self else { return }
                    self.togglePin(for: tracker)
                    self.togglePinImage(visibility: tracker.isPinned, for: cell)
                },
                UIAction(title: NSLocalizedString("trackers.editTracker", comment: "")) { [weak self]_ in
                    guard let self else { return }
                    analyticsService.report(event: "click", params: [
                        "screen": "Main",
                        "item": "edit"
                    ])
                    self.editTracker(tracker)
                },
                UIAction(title: NSLocalizedString(
                    "trackers.deleteTracker",
                    comment: ""
                ), attributes: .destructive) { [weak self] _ in
                    guard let self else { return }
                    self.analyticsService.report(event: "click", params: [
                        "screen": "Main",
                        "item": "delete"
                    ])
                    self.deleteAlert(for: tracker)
                }
            ])
        })
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

// MARK: - Private methods

private extension TrackersViewController {
    
    func layoutConfigure() {
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.1083),
            trackerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18),
            
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.centerYAnchor.constraint(equalTo: trackerLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            localizedDateLabel.widthAnchor.constraint(equalTo: datePicker.widthAnchor),
            localizedDateLabel.heightAnchor.constraint(equalTo: datePicker.heightAnchor),
            localizedDateLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
            localizedDateLabel.centerXAnchor.constraint(equalTo: datePicker.centerXAnchor),
            
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
            searchSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func checkMainPlaceholderVisability() {
        let isHidden = trackerStore.numberOfTrackers == 0 && searchSpacePlaceholderStack.isHidden
        mainSpacePlaceholderStack.isHidden = !isHidden
        filterButton.isHidden = isHidden
    }
    
    func checkPlaceholderVisabilityAfterSearch() {
        let isHidden = trackerStore.numberOfTrackers == 0 && searchedText != ""
        searchSpacePlaceholderStack.isHidden = !isHidden
    }
    
    func deleteAlert(for tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("trackers.deleteTrackerAlertTitle", comment: ""),
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("trackers.deleteTrackerAlertAction", comment: ""),
            style: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            do {
                try self.trackerStore.deleteTracker(tracker)
            } catch { }
        }
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("trackers.deleteTrackerAlertCancel", comment: ""),
            style: .cancel
        )
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    func togglePin(for tracker: Tracker) {
        try? trackerStore.togglePin(for: tracker)
    }
    
    func togglePinImage(visibility: Bool, for cell: TrackersCollectionCell) {
        cell.pinImageVisibitity(isVisible: visibility)
    }
    
    func editTracker(_ tracker: Tracker) {
        let constructorViewController = ConstructorViewController(editedTracker: tracker, tracker: tracker.values)
        let navigationController = UINavigationController(rootViewController: constructorViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: Actions
    
    @objc
    func didChangedDatePickerValue(_ sender: UIDatePicker) {
        currentDate = sender.date.getDate()!
        do {
            try trackerStore.getFilteredTrackers(date: currentDate, searchedText: searchedText)
            try trackerRecordStore.completedTrackers(by: currentDate)
        } catch {}
        localizedDateLabel.text = currentDate.getStringFromLocalizedDate()
        collectionView.reloadData()
    }
    
    @objc
    func didTapAddTrackerButton() {
        analyticsService.report(event: "click", params: [
            "screen": "Main",
            "item": "add_track"
        ])
        let createTrackerViewController = NewTrackerViewController()
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc
    func didTapFiltersButton() {
        analyticsService.report(event: "click", params: [
            "screen": "Main",
            "item": "filter"
        ])
        let TrackerFiltersViewController = TrackerFilteringViewController()
        let navigationController = UINavigationController(rootViewController: TrackerFiltersViewController)
        present(navigationController, animated: true)
    }
}
