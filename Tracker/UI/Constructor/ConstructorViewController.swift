import UIKit

struct Offsets {
    let textToTable: CGFloat = 24
    let tableToCollection: CGFloat = 32
    let collectionToButton: CGFloat = 21
    let buttonsToBottom: CGFloat = 24
}

protocol TrackerConstructorVCDelegate: AnyObject {
    func didTapConformButton(tracker: Tracker, category: TrackerCategory)
    func didTapCancelButton()
}

final class ConstructorViewController: UIViewController {
    // MARK: - UIElements
    private let contentView = UIView()
    private let scrollView = UIScrollView()
    private let categoryAndSchedulerTable = UITableView()
    private let cancelButton = UIButton(label: "Отменить")
    private let createButton = UIButton(label: "Создать")
    private let textField = CustomTextField()
    
    // MARK: - Properties
    private var trackerNameString: String = ""
    private var trackerEmogieString: String = ""
    private var trackerColor: UIColor?
    
    private var actionsArray: [TrackerConstructorTableViewActions] = [.init(titleLabelText: "Категория", subTitleLabel: "")]
    private lazy var currentSelectedCateory: TrackerCategory? = nil {
        didSet {
            checkIsCreateButtonActive()
        }
    }
    
    private let collectionViewSectionHeaders = ["Emoji", "Цвет"]
    private let emojies = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private var emojiSelectedItem: Int?
    private var colorSelectedItem: Int?
    private var selectedItem: IndexPath?
    private let isRegularEvent: Bool
    
    var scheduleVCCallback: (([DayOfWeek], String) -> Void)?
    weak var delegate: TrackerConstructorVCDelegate?
    
    let scrollViewInterElementOffsets: Offsets
    
    // MARK: - Lazy
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var textLimitLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(
            text: "Ограничение 38 символов",
            addToView: scrollView,
            ofSize: 17,
            weight: .regular
        )
        label.isHidden = true
        label.textColor = InterfaceColors.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textFieldStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        return stack
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
    
    private lazy var daysOfWeekForSceduler: [DayOfWeek] = {
        var sceduler: [DayOfWeek] = []
        if !isRegularEvent {
            for day in DayOfWeek.allCases {
                sceduler.append(day)
            }
        }
        return sceduler
    }()
    
    private lazy var headerText: String = {
        isRegularEvent == true ? "Новая привычка" : "Новое нерегулярное событие"
    }()
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerConfiguration()
        isNeedToAddSchedulerAction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initialSettings()
        layoutConfigure()
    }
    
    // MARK: - Layout configuraion
    private func layoutConfigure() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [categoryAndSchedulerTable, collectionView, buttonsStackView, textFieldStackView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        textFieldStackView.addArrangedSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            textFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryAndSchedulerTable.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24),
            categoryAndSchedulerTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryAndSchedulerTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryAndSchedulerTable.heightAnchor.constraint(equalToConstant: configureTableHeight()),
            
            collectionView.topAnchor.constraint(equalTo: categoryAndSchedulerTable.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            collectionView.heightAnchor.constraint(equalToConstant: 500),
            
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 21),
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        scrollView.layoutIfNeeded()
    }
    
    // MARK: - Layout configuration methods
    private func initialSettings() {
        view.backgroundColor = InterfaceColors.whiteDay
        textField.delegate = self
        configureCategoryAndSchedulerTable()
        configureScrollView()
        buttonsConfiguration()
        checkIsCreateButtonActive()
        configureTextField()
    }
    
    private func configureTableHeight() -> CGFloat {
        actionsArray.count == 1 ? 75 : 149
    }
    
    private func navigationControllerConfiguration() {
        title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: InterfaceColors.blackDay
        ]
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func buttonsConfiguration() {
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        cancelButton.setTitleColor(InterfaceColors.red, for: .normal)
        cancelButton.backgroundColor = InterfaceColors.backgruondDay
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = InterfaceColors.red.cgColor
        
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func configureScrollView() {
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.width, height: scrollViewHeightCalculation())
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        scrollView.isScrollEnabled = true
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isUserInteractionEnabled = true
        scrollView.delaysContentTouches = false
        
        let tapToHideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAndSaveTextFieldValue))
        tapToHideKeyboardGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapToHideKeyboardGesture)
    }
    
    private func textLimitLabelIs(visible: Bool) {
        UIView.animate(withDuration: 0.3) {
            if visible {
                self.textFieldStackView.addArrangedSubview(self.textLimitLabel)
                self.textLimitLabel.alpha = 1
            } else {
                self.textLimitLabel.alpha = 0
                self.textFieldStackView.removeArrangedSubview(self.textLimitLabel)
                self.textLimitLabel.removeFromSuperview()
            }
        }
    }
    
    private func scrollViewHeightCalculation() -> CGFloat {
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
    private func didTapCancelButton() {
        delegate?.didTapCancelButton()
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
            createButton.isButtonActive(isActive: true)
        } else {
            createButton.isButtonActive(isActive: false)
        }
    }
    
    @objc
    private func didTapCreateButton() {
        guard let color = trackerColor else { return }
        let tracker = Tracker(
            id: UUID.init(),
            label: trackerNameString,
            color: color,
            emoji: trackerEmogieString,
            schedule: daysOfWeekForSceduler,
            daysComplitedCount: 0
        )
        guard let unwrapCategory = currentSelectedCateory else { return }
        delegate?.didTapConformButton(tracker: tracker, category: unwrapCategory)
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
extension ConstructorViewController: UITableViewDataSource, UITableViewDelegate {
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
            let trackerCategorySelectorViewController = CategorySelectionViewController(selectedCategory: currentSelectedCateory)
            trackerCategorySelectorViewController.modalPresentationStyle = .pageSheet
            trackerCategorySelectorViewController.trackerCategorySelectorVCCallback = { [ weak self ] selectedCategory in
                guard let self = self else { return }
                self.actionsArray[0].subTitleLabel = selectedCategory.title
                self.currentSelectedCateory = selectedCategory
                self.checkIsCreateButtonActive()
                self.categoryAndSchedulerTable.reloadData()
            }
            show(trackerCategorySelectorViewController, sender: self)
        } else {
            let scheduleViewController = ScheduleViewController(
                daysOfWeekForSceduler: daysOfWeekForSceduler
            )
            scheduleViewController.modalPresentationStyle = .pageSheet
            scheduleViewController.scheduleVCCallback = { [ weak self ] schedule, cellSubviewText in
                guard let self = self else { return }
                self.scheduleVCCallback?(schedule, cellSubviewText)
                self.daysOfWeekForSceduler = schedule
                self.actionsArray[1].subTitleLabel = cellSubviewText
                self.checkIsCreateButtonActive()
                self.categoryAndSchedulerTable.reloadData()
            }
            show(scheduleViewController, sender: self)
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
        view.configoreLayout(leftOffset: 10, topOffset: topOffset, bottomOffset: 24)
        view.titleLabel.text = collectionViewSectionHeaders[indexPath.section]
        return view
    }
}



// MARK: - UICollectionViewDelegateFlowLayout Extension
extension ConstructorViewController: UICollectionViewDelegateFlowLayout {
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
extension ConstructorViewController: UICollectionViewDelegate {
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
extension ConstructorViewController: UITextFieldDelegate {
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
        let textFieldText = textField.text ?? ""
        let newLength = textFieldText.count + string.count - range.length
        let newText = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        checkIsCreateButtonActive()
        if newLength > 38 {
            textLimitLabelIs(visible: true)
        } else {
            textLimitLabelIs(visible: false)
        }
        return newLength <= 38
    }
}
