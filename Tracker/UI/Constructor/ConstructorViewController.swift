import UIKit

final class ConstructorViewController: UIViewController {
    // MARK: - Public properties
    let scrollViewInterElementOffsets: Offsets
    
    var scheduleVCCallback: (([DayOfWeek], String) -> Void)?
    
    // MARK: - Private properties
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let tableView = UITableView()
    private let cancelButton = UIButton(
        label: NSLocalizedString(
            "constructor.cancel",
            comment: ""
        )
    )
    private let createButton = UIButton(
        label: NSLocalizedString(
            "constructor.create", comment: ""
        )
    )
    private let textField = CustomTextField(with: NSLocalizedString("constructor.trackerName", comment: ""))
    private let textFieldStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    private lazy var textLimitLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("constructor.textLimitLabel", comment: "")
        label.textColor = .ypRed
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.register(
            CollectionEmojiCell.self,
            forCellWithReuseIdentifier: "emojieCell"
        )
        collection.register(
            CollectionColorCell.self,
            forCellWithReuseIdentifier: "colorCell"
        )
        collection.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collection.backgroundColor = .ypWhiteDay
        collection.isScrollEnabled = false
        collection.allowsMultipleSelection = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let isRegularEvent: Bool
    private let collectionViewSectionHeaders = [
        NSLocalizedString("constructor.emoji", comment: ""),
        NSLocalizedString("constructor.colors", comment: "")]
    private let emojies = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let trackerStore = TrackerStore()
    private var tracker: Tracker.Values{
        didSet {
            checkIsCreateButtonActive()
        }
    }
    private var editedTracker: Tracker?
    private var isEdit: Bool = false
    private var emojiSelectedItem: Int?
    private var colorSelectedItem: Int?
    private var selectedItem: IndexPath?
    private var actionsArray: [TrackerConstructorTableViewActions] = [.init(
        titleLabelText:
            NSLocalizedString(
                "constructor.category",
                comment: ""
            ),
        subTitleLabel: ""
    )]
    private lazy var currentSelectedCateory: TrackerCategory? = nil {
        didSet {
            checkIsCreateButtonActive()
        }
    }
    private lazy var scedule: [DayOfWeek] = {
        var scedule: [DayOfWeek] = []
        if !isRegularEvent {
            for day in DayOfWeek.allCases {
                scedule.append(day)
            }
        }
        return scedule
    }()
    private lazy var headerText: String = {
        if isRegularEvent {
            return NSLocalizedString("constructor.newHabit", comment: "")
        } else {
            return NSLocalizedString("constructor.newEvent", comment: "")
        }
    }()
    
    // MARK: - Lifecicle
    init(isRegularEvent: Bool) {
        self.isRegularEvent = isRegularEvent
        self.scrollViewInterElementOffsets = .init()
        self.tracker = Tracker.Values()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(editedTracker: Tracker, tracker: Tracker.Values) {
        self.isRegularEvent = true
        self.isEdit = true
        self.tracker = tracker
        self.editedTracker = editedTracker
        self.scrollViewInterElementOffsets = .init()
        super.init(nibName: nil, bundle: nil)
        isNeedToAddSchedulerAction()
        self.headerText = NSLocalizedString("constructor.edit", comment: "")
        self.actionsArray[0].subTitleLabel = tracker.category?.title ?? ""
        self.currentSelectedCateory = tracker.category
        self.textField.text = tracker.label
        guard let scedule = tracker.schedule else { return }
        self.scedule = scedule
        self.actionsArray[1].subTitleLabel = shortWeekDaysNamesCreation(schedule: tracker.schedule)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationControllerConfiguration()
        addingUIElements()
        configureScrollView()
        configureTableView()
        buttonsConfiguration()
        checkIsCreateButtonActive()
        isNeedToAddSchedulerAction()
        layoutConfigure()
    }
    
    // MARK: - Layout configuraion
    private func addingUIElements() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [tableView, collectionView, buttonsStackView, textFieldStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.addArrangedSubview(textLimitLabel)
        textLimitLabel.isHidden = true
    }
    
    private func layoutConfigure() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: view.frame.height + 45),
            
            textFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            textLimitLabel.bottomAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: configureTableHeight()),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            collectionView.heightAnchor.constraint(equalToConstant: 460),
            
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 21),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func shortWeekDaysNamesCreation(schedule: [DayOfWeek]?) -> String {
        guard let schedule = schedule else { return "" }
        var shortDaysOfWeekNames: [String] = []
        for day in schedule {
            shortDaysOfWeekNames.append(day.localizedStringShort)
        }
        if shortDaysOfWeekNames.count < 7 {
            let result = shortDaysOfWeekNames.joined(separator: ", ")
            return result
        } else {
            return NSLocalizedString("schedule.everyDay", comment: "")
        }
    }
    
    private func configureTableHeight() -> CGFloat {
        if actionsArray.count == 1 {
            tableView.separatorStyle = .none
            return 75
        } else {
            tableView.separatorStyle = .singleLine
            return 149
        }
    }
    
    private func navigationControllerConfiguration() {
        title = headerText
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlack
        ]
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func buttonsConfiguration() {
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func configureScrollView() {
        scrollView.frame = view.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        let tapToHideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAndSaveTextFieldValue))
        tapToHideKeyboardGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapToHideKeyboardGesture)
    }
    
    private func textLimitLabelIs(visible: Bool) {
        textLimitLabel.alpha = visible ? 1.0 : 0.0
        textLimitLabel.isHidden = !visible
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryAndSchedulerTableCell.self, forCellReuseIdentifier: "tableViewCell")
        tableView.separatorColor = .ypGray
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.isScrollEnabled = false
    }
    
    private func isNeedToAddSchedulerAction() {
        if isRegularEvent == true && !actionsArray.contains(where: {
            $0.titleLabelText == NSLocalizedString("constructor.schedule",comment: "")
        }) {
            actionsArray.append(.init(
                titleLabelText:
                    NSLocalizedString(
                        "constructor.schedule",
                        comment: ""
                    ),
                subTitleLabel: ""
            ))
        }
    }
    
    private func isNeedToSelectEmoji(for indexPath: IndexPath) -> Bool {
        emojies[indexPath.row] == tracker.emoji ? true : false
    }
    
    private func isNeedToSelectColor(for indexPath: IndexPath) -> Bool {
        cellColors[indexPath.row] == tracker.color ? true : false
    }
    
    // MARK: - Actions
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func hideKeyboardAndSaveTextFieldValue() {
        if textField.isFirstResponder {
            tracker.label = textField.text ?? ""
            textField.resignFirstResponder()
            checkIsCreateButtonActive()
        }
    }
    
    @objc
    private func checkIsCreateButtonActive() {
        if
            tracker.label != "",
            tracker.emoji != "",
            tracker.color != nil,
            self.actionsArray.allSatisfy({ $0.subTitleLabel != "" }) {
            createButton.isButtonActive(isActive: true)
        } else {
            createButton.isButtonActive(isActive: false)
        }
    }
    
    @objc
    private func didTapCreateButton() {
        guard let color = tracker.color,
              let category = currentSelectedCateory,
              let emoji = tracker.emoji
        else { return }
        let tracker = Tracker(
            id: UUID.init(),
            label: tracker.label,
            color: color,
            emoji: emoji,
            schedule: scedule,
            daysComplitedCount: self.tracker.daysComplitedCount,
            category: category
        )
        if isEdit {
            guard let editedTracker = editedTracker else { return }
            try? trackerStore.editTracker(tracker: editedTracker, with: self.tracker)
            dismiss(animated: true)
        } else {
            try? trackerStore.addTracker(tracker: tracker, with: category)
            dismiss(animated: true)
        }
    }
}


// MARK: - UITableViewDataSource Extension
extension ConstructorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as?
                CategoryAndSchedulerTableCell else {fatalError("Invalid cell configuration")}
        cell.configure(
            title: actionsArray[indexPath.row].titleLabelText,
            subTitle: actionsArray[indexPath.row].subTitleLabel
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let trackerCategorySelectorViewController = CategorySelectionViewController(selectedCategory: currentSelectedCateory)
            let navigatonVC = UINavigationController(rootViewController: trackerCategorySelectorViewController)
            trackerCategorySelectorViewController.trackerCategorySelectorVCCallback = { [ weak self ] selectedCategory in
                guard let self = self else { return }
                self.actionsArray[0].subTitleLabel = selectedCategory.title
                self.currentSelectedCateory = selectedCategory
                self.tracker.category = selectedCategory
                self.checkIsCreateButtonActive()
                self.tableView.reloadData()
            }
            present(navigatonVC, animated: true)
        } else {
            let scheduleViewController = ScheduleViewController(daysInScedule: scedule)
            let navigatonVC = UINavigationController(rootViewController: scheduleViewController)
            scheduleViewController.scheduleVCCallback = { [ weak self ] schedule, cellSubviewText in
                guard let self = self else { return }
                self.scheduleVCCallback?(schedule, cellSubviewText)
                self.scedule = schedule
                self.tracker.schedule = schedule
                self.actionsArray[1].subTitleLabel = cellSubviewText
                self.checkIsCreateButtonActive()
                self.tableView.reloadData()
            }
            present(navigatonVC, animated: true)
        }
    }
}


// MARK: - UICollectionViewDataSource Extension
extension ConstructorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewSectionHeaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 :
            return emojies.count
        case 1:
            return cellColors.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojieCell", for: indexPath) as? CollectionEmojiCell
            else { fatalError("Cell configure error!") }
            cell.setEmojieLabel(emojie: emojies[indexPath.row])
            let isSelected = isNeedToSelectEmoji(for: indexPath)
            cell.cellIsSelected(state: isSelected)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? CollectionColorCell
            else { fatalError("Cell configure error!") }
            cell.setCellColor(color: cellColors[indexPath.row])
            let isSelected = isNeedToSelectColor(for: indexPath)
            cell.cellIsSelected(state: isSelected)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
        default:
            id = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView
        else {fatalError("Supplementary view configuration error")}
        let topOffset: CGFloat = indexPath.section == 0 ? 0 : 40
        view.configoreLayout(leftOffset: 10, topOffset: topOffset, bottomOffset: 24)
        view.titleLabel.text = collectionViewSectionHeaders[indexPath.section]
        view.titleLabel.textColor = .ypBlack
        return view
    }
}


// MARK: - UICollectionViewDelegateFlowLayout Extension
extension ConstructorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}


// MARK: - UICollectionViewDelegate Extension
extension ConstructorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedItem = indexPath
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                if item != indexPath.row {
                    let indexPath = IndexPath(item: item, section: 0)
                    let cell = collectionView.cellForItem(at: indexPath) as? CollectionEmojiCell
                    cell?.cellIsSelected(state: false)
                }
                let cell = collectionView.cellForItem(at: indexPath) as? CollectionEmojiCell
                cell?.cellIsSelected(state: true)
                tracker.emoji = emojies[indexPath.row]
                emojiSelectedItem = indexPath.item
                checkIsCreateButtonActive()
            }
        case 1:
            for item in 0..<collectionView.numberOfItems(inSection: 1) {
                if item != indexPath.row {
                    let indexPath = IndexPath(item: item, section: 1)
                    let cell = collectionView.cellForItem(at: indexPath) as? CollectionColorCell
                    cell?.cellIsSelected(state: false)
                }
                let cell = collectionView.cellForItem(at: indexPath) as? CollectionColorCell
                cell?.cellIsSelected(state: true)
                tracker.color = cellColors[indexPath.row]
                colorSelectedItem = indexPath.item
                checkIsCreateButtonActive()
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let section = selectedItem?.section else { return }
        switch section {
        case 0:
            guard let item = emojiSelectedItem,
                  let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? CollectionEmojiCell
            else { return }
            cell.cellIsSelected(state: false)
            
        case 1:
            guard let item = colorSelectedItem,
                  let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? CollectionColorCell
            else { return }
            cell.cellIsSelected(state: false)
            
        default: break
        }
    }
}


// MARK: - UITextFieldDelegate Extension
extension ConstructorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tracker.label = textField.text ?? ""
        textField.resignFirstResponder()
        checkIsCreateButtonActive()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        tracker.label = textField.text ?? ""
        checkIsCreateButtonActive()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText = textField.text ?? ""
        let newLength = textFieldText.count + string.count - range.length
        let limitLabelVisibility = newLength > 38
        checkIsCreateButtonActive()
        textLimitLabelIs(visible: limitLabelVisibility)
        
        return newLength <= 38
    }
}
