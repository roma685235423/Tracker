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
    private let trackerCategoryStore = TrackerCategoryStore()
    private var selectedItem: Int?
    
    private lazy var trackersCategories: [String] = {
        var stringCategories: [String] = []
        for category in trackerCategoryStore.categories {
            stringCategories.append(category.title)
        }
        return stringCategories
    }()
    
    var trackerCategorySelectorVCCallback: ((String, Int?) -> Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
        checkMainPlaceholderVisibility()
    }
    
    // MARK: - UI Configuration methods
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
        trackerCategoryTable.layer.cornerRadius = 16
        trackerCategoryTable.separatorStyle = .none
        trackerCategoryTable.layer.masksToBounds = true
        trackerCategoryTable.isDirectionalLockEnabled = true
        trackerCategoryTable.register(CategorySelectionCell.self, forCellReuseIdentifier: CategorySelectionCell.identifier)
    }
    
    
    // MARK: - Layout Configuration
    private func configureLayout() {
        [screenTopLabel, trackerCategoryTable, addCategoryButton, mainSpacePlaceholderStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainSpacePlaceholderStack.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 246),
            mainSpacePlaceholderStack.widthAnchor.constraint(equalToConstant: 180),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            trackerCategoryTable.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCategoryTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -30)
        ])
    }
    
    // MARK: - Methods
    private func calculateTableHeight() -> CGFloat {
        if trackersCategories.count > 1 {
            return CGFloat((trackersCategories.count * 75) - 1)
        } else if trackersCategories.isEmpty {
            return 0
        } else {
            return 74
        }
    }
    
    private func checkMainPlaceholderVisibility() {
        let isHidden = trackersCategories.count < 1
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    @objc private func didTapAddCategoryButton() {
        let trackerCategoryCreationViewController = TrackerCategoryCreationViewController()
        trackerCategoryCreationViewController.modalPresentationStyle = .pageSheet
        present(trackerCategoryCreationViewController, animated: true)
    }
    
    // MARK: - init
    init(currentItem: Int?) {
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
        guard let cell = tableView.cellForRow(at: indexPath),
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
        return trackersCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategorySelectionCell.identifier) as? CategorySelectionCell else {
            return UITableViewCell()
        }
        
        let categoryName = trackersCategories[indexPath.row]
        let isSelected = indexPath.row % 2 == 0 ? true : false
        cell.configureCell(
            with: categoryName,
            isSelected: isSelected,
            cellIndex: indexPath.row,
            totalRowsInTable: trackersCategories.count
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
