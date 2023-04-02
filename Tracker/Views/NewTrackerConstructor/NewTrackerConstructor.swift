import UIKit

final class NewTrackerConstructor: UIInputViewController {
    // MARK: - UIElements
    private let isRegularEvent: Bool
    private let screenTopLabel = UILabel()
    private let scrollView = UIScrollView()
    private let textField = MyTextField()
    private let categoryAndSchedulerTable = UITableView()
    private var actionsArray: [String] = ["Категория"]
    private let emojies = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let collectionViewSectionHeaders = ["Emoji", "Цвет"]
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
        return button
    }()
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.textColor = InterfaceColors.whiteDay
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = InterfaceColors.gray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
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
        collection.register(EmojiCell.self, forCellWithReuseIdentifier: "emojieCell")
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.backgroundColor = InterfaceColors.whiteDay
        return collection
    }()
    
    private lazy var headerText: String = {
        isRegularEvent == true ? "Новая привычка" : "Новое нерегулярное событие"
    }()
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    // MARK: - Methods
    private func initialSettings() {
        view.backgroundColor = InterfaceColors.whiteDay
        textField.delegate = self
        scrollView.delegate = self
        isNeedToAddSchedulerAction()
        configureCategoryAndSchedulerTable()
        screenTopLabel.configureLabel(
            text: headerText,
            addToView: view,
            ofSize: 16,
            weight: .medium)
        configureTextField()
        setConstraints()
    }
    
    private func setConstraints() {
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
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 14),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryAndSchedulerTable.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            categoryAndSchedulerTable.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            categoryAndSchedulerTable.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            categoryAndSchedulerTable.heightAnchor.constraint(equalToConstant: configureTableHeight()),
            
            collectionView.topAnchor.constraint(equalTo: categoryAndSchedulerTable.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureTableHeight() -> CGFloat {
        actionsArray.count == 1 ? 75 : 149
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
            actionsArray.append("Расписание")
        }
    }
    
    init(isRegularEvent: Bool) {
        self.isRegularEvent = isRegularEvent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - Extensions
extension NewTrackerConstructor: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        actionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = actionsArray[indexPath.row]
        cell.textLabel?.textColor = InterfaceColors.blackDay
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.selectionStyle = .none
        cell.backgroundColor = InterfaceColors.backgruondDay
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}


extension NewTrackerConstructor: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewSectionHeaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emojies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojieCell", for: indexPath) as? EmojiCell
        else { fatalError("Cell configure error!") }
        cell.emojiLabel.text = emojies[indexPath.row]
        return cell
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
        view.titleLabel.text = collectionViewSectionHeaders[indexPath.row]
        return view
    }
}

extension NewTrackerConstructor: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width/6, height: collectionView.bounds.width/6)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
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

extension NewTrackerConstructor: UIScrollViewDelegate, UITableViewDelegate, UITextFieldDelegate, UICollectionViewDelegate {
}
