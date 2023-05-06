import UIKit

struct Offsets {
    let textToTable: CGFloat = 24
    let tableToCollection: CGFloat = 32
    let collectionToButton: CGFloat = 21
    let buttonsToBottom: CGFloat = 24
}

protocol NewRegularTrackerConstructorDelegate: AnyObject {
    func getTrackersCategories() -> [String]
}



final class NewTrackerConstructorViewController: UIViewController {
    // MARK: - UIElements
    private let screenTopLabel = UILabel()
    private let scrollView = UIScrollView()
    private let textField = MyTextField()
    private let categoryAndSchedulerTable = UITableView()
    
    // MARK: - Properties
    private var trackerNameString: String = ""
    private var trackerEmogieString: String = ""
    private var trackerCategoryString: String = ""
    private var trackerColor: UIColor?
    
    private var actionsArray: [TableViewActions] = [.init(titleLabelText: "Категория", subTitleLabel: "")]
    private var currentSelectedCateory: Int?
    
    private var dailySchedule: [DailySchedule] = [
        DailySchedule(dayOfWeek: "Понедельник", dayOfWeekNumber: 2),
        DailySchedule(dayOfWeek: "Вторник", dayOfWeekNumber: 3),
        DailySchedule(dayOfWeek: "Среда", dayOfWeekNumber: 4),
        DailySchedule(dayOfWeek: "Четверг", dayOfWeekNumber: 5),
        DailySchedule(dayOfWeek: "Пятница", dayOfWeekNumber: 6),
        DailySchedule(dayOfWeek: "Суббота", dayOfWeekNumber: 7),
        DailySchedule(dayOfWeek: "Воскресенье", dayOfWeekNumber: 1)
    ]
    
    private let collectionViewSectionHeaders = ["Emoji", "Цвет"]
    private let emojies = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private var emojiSelectedItem: Int?
    private var colorSelectedItem: Int?
    private var selectedItem: IndexPath?
    
    private let isRegularEvent: Bool
    weak var deleagte: NewRegularTrackerConstructorDelegate?
    
    var trackersVCCancelCallback: (() -> Void)?
    var trackersVCCreateCallback: ((String, Tracker) -> Void)?
    
    var scheduleVCCallback: (([DailySchedule], String) -> Void)?
    var trackerCategorySelectorVCCallback: ((String) -> Void)?
    
    let scrollViewInterElementOffsets: Offsets
    
    // MARK: - Lazy
    private lazy var trackersCategories: [String] = {
        guard let categories = deleagte?.getTrackersCategories() else { return [] }
        return categories
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(InterfaceColors.red, for: .normal)
        button.backgroundColor = InterfaceColors.backgruondDay
        button.layer.borderWidth = 1
        button.layer.borderColor = InterfaceColors.red.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.textColor = InterfaceColors.whiteDay
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.register(CollectionEmojiCell.self, forCellWithReuseIdentifier: "emojieCell")
        collection.register(CollectionColorCell.self, forCellWithReuseIdentifier: "colorCell")
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.backgroundColor = InterfaceColors.whiteDay
        collection.isScrollEnabled = false
        collection.allowsMultipleSelection = false
        return collection
    }()
    
    private lazy var headerText: String = {
        isRegularEvent == true ? "Новая привычка" : "Новое нерегулярное событие"
    }()
    
    
    // MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNeedToAddSchedulerAction()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialSettings()
    }
    
    
    
    // MARK: - Layout configuraion
    private func layoutConfigure() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        categoryAndSchedulerTable.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(textField)
        scrollView.addSubview(categoryAndSchedulerTable)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.0515),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: view.frame.height * 0.0744),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryAndSchedulerTable.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: scrollViewInterElementOffsets.textToTable),
            categoryAndSchedulerTable.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            categoryAndSchedulerTable.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            categoryAndSchedulerTable.heightAnchor.constraint(equalToConstant: configureTableHeight()),
            
            collectionView.topAnchor.constraint(equalTo: categoryAndSchedulerTable.bottomAnchor, constant: scrollViewInterElementOffsets.tableToCollection),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            collectionView.heightAnchor.constraint(equalToConstant: 470),
            
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: scrollViewInterElementOffsets.collectionToButton),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        scrollView.layoutIfNeeded()
    }
    
    
    // MARK: - Layout methods
    private func initialSettings() {
        view.backgroundColor = InterfaceColors.whiteDay
        textField.delegate = self
        configureTextField()
        configureCategoryAndSchedulerTable()
        screenTopLabel.configureLabel(
            text: headerText,
            addToView: view,
            ofSize: 16,
            weight: .medium)
        layoutConfigure()
        configureScrollView()
        checkIsCreateButtonActive()
    }
    
    
    private func configureTableHeight() -> CGFloat {
        actionsArray.count == 1 ? 75 : 149
    }
    
    
    private func configureScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollViewHeightCalculation())
        let tapToHideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAndSaveTextFieldValue))
        tapToHideKeyboardGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapToHideKeyboardGesture)
    }
    
    private func scrollViewHeightCalculation() -> CGFloat{
        return textField.frame.height + scrollViewInterElementOffsets.textToTable +
        categoryAndSchedulerTable.frame.height + scrollViewInterElementOffsets.tableToCollection +
        collectionView.frame.height + scrollViewInterElementOffsets.collectionToButton +
        buttonsStackView.frame.height + scrollViewInterElementOffsets.buttonsToBottom
    }
    
    
    private func configureTextField() {
        textField.backgroundColor = InterfaceColors.backgruondDay
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .default
        textField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [
                NSAttributedString.Key.foregroundColor: InterfaceColors.gray,
            ]
        )
    }
    
    
    // MARK: - Methods
    private func makeCreateButtonActive(isActive: Bool) {
        createButton.isEnabled = isActive
        let backgroundColor = isActive ? InterfaceColors.blackDay : InterfaceColors.gray
        createButton.backgroundColor = backgroundColor
    }
    
    
    private func configureCategoryAndSchedulerTable() {
        categoryAndSchedulerTable.delegate = self
        categoryAndSchedulerTable.dataSource = self
        categoryAndSchedulerTable.register(CategoryAndSchedulerTableCell.self, forCellReuseIdentifier: "tableViewCell")
        categoryAndSchedulerTable.backgroundColor = InterfaceColors.backgruondDay
        categoryAndSchedulerTable.separatorColor = InterfaceColors.gray
        categoryAndSchedulerTable.layer.cornerRadius = 16
        categoryAndSchedulerTable.layer.masksToBounds = true
        categoryAndSchedulerTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        categoryAndSchedulerTable.isScrollEnabled = false
        if actionsArray.count == 1 {
            categoryAndSchedulerTable.separatorStyle = .none
        }
    }
    
    
    private func isNeedToAddSchedulerAction() {
        if isRegularEvent == true {
            actionsArray.append(.init(titleLabelText: "Расписание", subTitleLabel: ""))
        }
    }
    
    
    // MARK: - Actions
    @objc
    private func didTapCreateButton() {
        guard let color = trackerColor else { return }
        let scheduler = dailySchedule.filter { $0.schedulerIsActive }
        let tracker = Tracker(
            id: UUID.init(),
            label: trackerNameString,
            color: color,
            emoji: trackerEmogieString,
            dailySchedule: isRegularEvent ? scheduler : nil,
            daysComplitedCount: 0
        )
        trackersVCCreateCallback?(trackerCategoryString, tracker)
    }
    
    
    @objc
    private func didTapCancelButton() {
        trackersVCCancelCallback?()
    }
    
    
    @objc
    private func hideKeyboardAndSaveTextFieldValue() {
        if textField.isFirstResponder {
            trackerNameString = textField.text ?? ""
            textField.resignFirstResponder()
            checkIsCreateButtonActive()
        }
    }
    
    
    @objc
    private func checkIsCreateButtonActive() {
        if self.trackerNameString != "",
           self.trackerEmogieString != "",
           self.trackerColor != nil,
           self.actionsArray.allSatisfy({ $0.subTitleLabel != "" }) {
            makeCreateButtonActive(isActive: true)
        } else {
            makeCreateButtonActive(isActive: false)
        }
    }
    
    
    // MARK: - Init
    init(isRegularEvent: Bool) {
        self.isRegularEvent = isRegularEvent
        self.scrollViewInterElementOffsets = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - UITableViewDataSource Extension
extension NewTrackerConstructorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actionsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryAndSchedulerTable.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as?
                CategoryAndSchedulerTableCell else {fatalError("Invalid cell configuration")}
        cell.configure(title: actionsArray[indexPath.row].titleLabelText, subTitle: actionsArray[indexPath.row].subTitleLabel)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let trackerCategorySelectorViewController = TrackerCategorySelectorViewController(categoryes: trackersCategories, currentItem: currentSelectedCateory)
            trackerCategorySelectorViewController.modalPresentationStyle = .pageSheet
            trackerCategorySelectorViewController.trackerCategorySelectorVCCallback = { [ weak self ] cellSubviewText, selectedItem in
                guard let self = self else { return }
                self.actionsArray[0].subTitleLabel = cellSubviewText
                self.trackerCategoryString = cellSubviewText
                self.currentSelectedCateory = selectedItem
                self.checkIsCreateButtonActive()
                self.categoryAndSchedulerTable.reloadData()
            }
            show(trackerCategorySelectorViewController, sender: self)
        } else {
            let scheduleViewController = ScheduleViewController(dailySchedule: dailySchedule)
            scheduleViewController.modalPresentationStyle = .pageSheet
            scheduleViewController.scheduleVCCallback = { [ weak self ] data, cellSubviewText in
                guard let self = self else { return }
                self.scheduleVCCallback?(data, cellSubviewText)
                self.dailySchedule = data
                self.actionsArray[1].subTitleLabel = cellSubviewText
                self.checkIsCreateButtonActive()
                self.categoryAndSchedulerTable.reloadData()
            }
            show(scheduleViewController, sender: self)
        }
    }
}



// MARK: - UICollectionViewDataSource Extension
extension NewTrackerConstructorViewController: UICollectionViewDataSource {
    
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
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? CollectionColorCell
            else { fatalError("Cell configure error!") }
            cell.setCellColor(color: cellColors[indexPath.row])
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
        view.configoreLayout(leftOffset: 1, topOffset: topOffset, bottomOffset: 24)
        view.titleLabel.text = collectionViewSectionHeaders[indexPath.section]
        return view
    }
}



// MARK: - UICollectionViewDelegateFlowLayout Extension
extension NewTrackerConstructorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/6, height: collectionView.bounds.width/6)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel
        )
    }
}



// MARK: - UICollectionViewDelegate Extension
extension NewTrackerConstructorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedItem = indexPath
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let cell = collectionView.cellForItem(at: indexPath) as? CollectionEmojiCell
            cell?.cellIsSelected(state: true)
            trackerEmogieString = emojies[indexPath.row]
            emojiSelectedItem = indexPath.item
            checkIsCreateButtonActive()
        case 1:
            let cell = collectionView.cellForItem(at: indexPath) as? CollectionColorCell
            cell?.cellIsSelected(state: true)
            trackerColor = cellColors[indexPath.row]
            colorSelectedItem = indexPath.item
            checkIsCreateButtonActive()
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
extension NewTrackerConstructorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerNameString = textField.text ?? ""
        textField.resignFirstResponder()
        checkIsCreateButtonActive()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        trackerNameString = textField.text ?? ""
        checkIsCreateButtonActive()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        trackerNameString = textField.text ?? ""
        checkIsCreateButtonActive()
        return true
    }
}


// MARK: - Extensions
extension NewTrackerConstructorViewController: UITableViewDelegate {
    
}
