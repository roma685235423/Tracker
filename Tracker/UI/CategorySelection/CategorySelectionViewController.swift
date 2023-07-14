import UIKit

final class CategorySelectionViewController: UIViewController {
    // MARK: - Public properties
    var trackerCategorySelectorVCCallback: ((TrackerCategory) -> Void)?
    
    // MARK: - Private properties
    private let trackerCategoryTable = UITableView()
    private let mainSpacePlaceholderStack = UIStackView(
        imageName: "starPlaceholder",
        text: NSLocalizedString("categorySelection.mainPlaceholder", comment: "")
    )
    private lazy var addCategoryButton = UIButton(
        label: NSLocalizedString(
            "categorySelection.addCategory",
            comment: ""
        )
    )
    
    private let viewModel: CategorySelectionViewModel
    
    // MARK: - Life Cycle
    init(selectedCategory: TrackerCategory?) {
        self.viewModel = CategorySelectionViewModel(for: selectedCategory)
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
        viewModel.loadCategories()
    }
    
    // MARK: - Public methods
    func refreshTableView() {
        trackerCategoryTable.reloadData()
        mainSpacePlaceholderStack.isHidden = viewModel.isCategoriesExist()
    }
    
    // MARK: - Layout Configuration
    private func addingUIElements() {
        [trackerCategoryTable, addCategoryButton, mainSpacePlaceholderStack].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            mainSpacePlaceholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainSpacePlaceholderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainSpacePlaceholderStack.widthAnchor.constraint(equalToConstant: 180),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            trackerCategoryTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerCategoryTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -30)
        ])
    }
    
    // MARK: - Private methods
    private func bindViewModel() {
        viewModel.updateVMCallback = { [weak self] update in
            guard let self else { return }
            self.trackerCategoryTable.performBatchUpdates {
                self.trackerCategoryTable.insertRows(at: update.newIndexes, with: .automatic)
                self.trackerCategoryTable.deleteRows(at: update.deletedIndexes, with: .automatic)
            }
        }
    }
    
    private func initialSettings() {
        view.backgroundColor = .ypWhite
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        configurenavigationController()
        configureTrackerCategoryTable()
        addingUIElements()
        layoutConfigure()
    }
    
    private func configurenavigationController() {
        title = NSLocalizedString("categorySelection.category", comment: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlack
        ]
    }
    
    private func configureTrackerCategoryTable() {
        trackerCategoryTable.delegate = self
        trackerCategoryTable.dataSource = self
        trackerCategoryTable.layer.cornerRadius = 16
        trackerCategoryTable.separatorStyle = .none
        trackerCategoryTable.backgroundColor = .clear
        trackerCategoryTable.layer.masksToBounds = true
        trackerCategoryTable.isDirectionalLockEnabled = true
        trackerCategoryTable.register(TableViewCellWithBlueCheckmark.self, forCellReuseIdentifier: TableViewCellWithBlueCheckmark.identifier)
    }
    
    // MARK: - Actions
    @objc private func didTapAddCategoryButton() {
        let trackerCategoryCreationViewController = NewCategoryViewController(viewModel: viewModel)
        let navigationVC = UINavigationController(rootViewController: trackerCategoryCreationViewController)
        trackerCategoryCreationViewController.modalPresentationStyle = .pageSheet
        present(navigationVC, animated: true)
    }
}


// MARK: - UITableViewDelegate Extension
extension CategorySelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = viewModel.categories[indexPath.row]
        for cell in tableView.visibleCells {
            guard let categoryCell = cell as? TableViewCellWithBlueCheckmark,
                  let cellIndexPath = tableView.indexPath(for: categoryCell) else { continue }
            let category = viewModel.categories[cellIndexPath.row]
            let isCheckmarkVisible = category.id != selectedCategory.id
            categoryCell.checkmarkIs(visible: isCheckmarkVisible)
        }
        trackerCategorySelectorVCCallback?(selectedCategory)
        viewModel.selectCategory(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}


// MARK: - UITableViewDataSource Extension
extension CategorySelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithBlueCheckmark.identifier) as? TableViewCellWithBlueCheckmark else {
            return UITableViewCell()
        }
        cell.resetSeparatorVisibility()
        let categoryName = viewModel.categories[indexPath.row].title
        let isSelected = viewModel.isCheckmarkVisible(in: indexPath.row)
        cell.configureCell(
            with: categoryName,
            isSelected: isSelected,
            cellIndex: indexPath.row,
            totalRowsInTable: viewModel.categoriesCount()
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}


// MARK: - CategorySelectionViewModelDelegate
extension CategorySelectionViewController: CategorySelectionViewModelDelegate {
    func categoriesDidUpdate() {
        trackerCategoryTable.reloadData()
        mainSpacePlaceholderStack.isHidden = viewModel.isCategoriesExist()
    }
    
    func categoryDidSelect() {
        dismiss(animated: true, completion: nil)
    }
    
    func add(newCategory: TrackerCategory) {
        viewModel.add(newCategory: newCategory)
    }
}
