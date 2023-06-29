import UIKit

final class CategorySelectionViewController: UIViewController {
    // MARK: - Public properties
    var trackerCategorySelectorVCCallback: ((TrackerCategory) -> Void)?
    
    // MARK: - Private properties
    private let trackerCategoryTable = UITableView()
    private let mainSpacePlaceholderStack = UIStackView(
        imageName: "starPlaceholder",
        text: "Привычки и события можно объединить по смыслу"
    )
    private lazy var addCategoryButton = UIButton(label: "Добавить категорию")
    
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
    private func initialSettings() {
        view.backgroundColor = .ypWhiteDay
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
        configurenavigationController()
        configureTrackerCategoryTable()
        addingUIElements()
        layoutConfigure()
    }
    
    private func configurenavigationController() {
        title = "Категория"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlackDay
        ]
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
    
    // MARK: - Actions
    @objc private func didTapAddCategoryButton() {
        let trackerCategoryCreationViewController = CategoryCreationViewController()
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
            guard let categoryCell = cell as? CategorySelectionCell,
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategorySelectionCell.identifier) as? CategorySelectionCell else {
            return UITableViewCell()
        }
        
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
        mainSpacePlaceholderStack.isHidden = viewModel.isCategoriesExist()
    }
    
    func didSelect(category: TrackerCategory) {
        dismiss(animated: true, completion: nil)
    }
}
