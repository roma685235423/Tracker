import UIKit

final class NewTrackerConstructor: UIInputViewController {
    // MARK: - UIElements
    private let isRegularEvent: Bool
    private let screenTopLabel = UILabel()
    private let textField = MyTextField()
    private let categoryAndSchedulerTable = UITableView()
    private var actionsArray: [String] = ["Категория"]
    
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
        categoryAndSchedulerTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryAndSchedulerTable)
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryAndSchedulerTable.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            categoryAndSchedulerTable.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            categoryAndSchedulerTable.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            categoryAndSchedulerTable.heightAnchor.constraint(equalToConstant: configureTableHeight())
        ])
    }
    
    private func configureTableHeight() -> CGFloat {
        actionsArray.count == 1 ? 75 : 149
    }
    
    private func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
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
        categoryAndSchedulerTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryAndSchedulerTable)
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

extension NewTrackerConstructor: UITextFieldDelegate {
    
}

extension NewTrackerConstructor: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
