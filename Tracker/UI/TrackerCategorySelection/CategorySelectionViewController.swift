import UIKit

final class TrackerCategorySelectionVC: UIViewController {
    // MARK: - UI
    private let screenTopLabel = UILabel()
    private let trackerCategoryTable = UITableView()
    private lazy var addCategoryButton = UIButton(label: "Добавить категорию")
    private let mainSpacePlaceholderStack = UIStackView(
        imageName: "starPlaceholder",
        text: "Привычки и события можно объединить по смыслу"
    )
    
    
    // MARK: - Properties
//    private var viewModel: CategorySelectionViewModel
//    private var selectedCategory: TrackerCategory?
    
    private var categories: [String]
    private var selectedItem: Int?
    var trackerCategorySelectorVCCallback: ((String, Int?) -> Void)?
    
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
        checkMainPlaceholderVisability()
    }
    
    
    // MARK: - UIConfiguration methods
    private func initialSettings() {
        view.backgroundColor = InterfaceColors.whiteDay
        screenTopLabel.configureLabel(
            text: "Категория",
            addToView: view,
            ofSize: 16,
            weight: .medium
        )
        configureTrackerCategoryTable()
        configureLayout()
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
    
    
    private func configureTrackerCategoryTable() {
        trackerCategoryTable.delegate = self
        trackerCategoryTable.dataSource = self
        trackerCategoryTable.separatorColor = InterfaceColors.gray
        trackerCategoryTable.layer.cornerRadius = 16
        trackerCategoryTable.layer.masksToBounds = true
        trackerCategoryTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        trackerCategoryTable.isScrollEnabled = true
    }
    
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        screenTopLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerCategoryTable.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenTopLabel)
        view.addSubview(trackerCategoryTable)
        view.addSubview(addCategoryButton)
        view.addSubview(mainSpacePlaceholderStack)
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackerCategoryTable.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCategoryTable.heightAnchor.constraint(equalToConstant: calculateTableSize()),
//            trackerCategoryTable.heightAnchor.constraint(equalToConstant: viewModel.calculateTableSize()),
            
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 246),
            mainSpacePlaceholderStack.widthAnchor.constraint(equalToConstant: 180),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    
    // MARK: - Methods
    private func calculateTableSize() -> CGFloat {
        if categories.count > 1 {
            return CGFloat((categories.count * 75) - 1)
        } else if categories.count == 0 {
            return 0
        } else {
            return 74
        }
    }
    
    
    private func checkMainPlaceholderVisability() {
        let isHidden = categories.count < 1
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    
    @objc
    private func didTapAddCategoryButton() {
        let trackerCategoryCreationViewController = TrackerCategoryCreationViewController()
        trackerCategoryCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCategoryCreationViewController, animated: true)
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
extension TrackerCategorySelectionVC: UITableViewDelegate {
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
extension TrackerCategorySelectionVC: UITableViewDataSource {
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
