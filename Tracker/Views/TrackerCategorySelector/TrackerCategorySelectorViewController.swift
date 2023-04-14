import UIKit

final class TrackerCategorySelectorViewController: UIViewController {
    // MARK: - UI
    private let screenTopLabel = UILabel()
    private let trackerCategoryTable = UITableView()
    private lazy var readyButton = UIButton()
    
    // MARK: - Properties
    private var categories: [String]
    private var selectedItem: Int?
    var trackerCategorySelectorVCCallback: ((String, Int?) -> Void)?
    
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    
    // MARK: - UIConfiguration methods
    private func initialSettings() {
        view.backgroundColor = InterfaceColors.whiteDay
        screenTopLabel.configureLabel(
            text: "Расписание",
            addToView: view,
            ofSize: 16,
            weight: .medium
        )
        configureTrackerCategoryTable()
        configureReadyButton()
        configureLayout()
    }
    
    
    private func configureTrackerCategoryTable() {
        trackerCategoryTable.delegate = self
        trackerCategoryTable.dataSource = self
        trackerCategoryTable.separatorColor = InterfaceColors.gray
        trackerCategoryTable.layer.cornerRadius = 16
        trackerCategoryTable.layer.masksToBounds = true
        trackerCategoryTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        trackerCategoryTable.isScrollEnabled = false
    }
    
    
    private func configureReadyButton() {
        readyButton.backgroundColor = InterfaceColors.blackDay
        readyButton.setTitle("Добавить категорию", for: .normal)
        readyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        readyButton.titleLabel?.textColor = InterfaceColors.whiteDay
        readyButton.layer.cornerRadius = 16
        readyButton.layer.masksToBounds = true
    }
    
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        screenTopLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerCategoryTable.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenTopLabel)
        view.addSubview(trackerCategoryTable)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackerCategoryTable.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCategoryTable.heightAnchor.constraint(equalToConstant: calculateTableSize()),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    
    // MARK: - Methods
    private func calculateTableSize() -> CGFloat {
        if categories.count > 1 {
            return CGFloat((categories.count * 75) - 1)
        } else if categories.count == 0 {
            return 0
        } else {
            return 75
        }
    }
    
    
    // MARK: - init
    init(categoryes: [String], currentItem: Int?) {
        self.categories = categoryes
        self.selectedItem = currentItem
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - UITableViewDelegate Extension
extension TrackerCategorySelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let cell = cell,
              let text = cell.textLabel?.text
        else { return }
        cell.accessoryType = .checkmark
        trackerCategorySelectorVCCallback?(text, indexPath.row)
        dismiss(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}



// MARK: - UITableViewDataSource Extension
extension TrackerCategorySelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.textColor = InterfaceColors.blackDay
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.tintColor = InterfaceColors.blue
        if indexPath.row == selectedItem{
            cell.accessoryType = .checkmark
        }
        cell.selectionStyle = .none
        cell.backgroundColor = InterfaceColors.backgruondDay
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
