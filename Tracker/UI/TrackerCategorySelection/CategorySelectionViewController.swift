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
    
    private lazy var scrollView = UIScrollView()
    
    
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
        configureScrollView()
        addCategoryButton.addTarget(self, action: #selector(didTapAddCategoryButton), for: .touchUpInside)
    }
    
    
    private func configureTrackerCategoryTable() {
        trackerCategoryTable.delegate = self
        trackerCategoryTable.dataSource = self
        trackerCategoryTable.separatorColor = InterfaceColors.gray
        trackerCategoryTable.layer.cornerRadius = 16
        trackerCategoryTable.layer.masksToBounds = true
        trackerCategoryTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        trackerCategoryTable.isScrollEnabled = false
        trackerCategoryTable.register(CategorySelectionCell.self, forCellReuseIdentifier: CategorySelectionCell.identifier)
    }
    
    
    private func configureScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: calculateTableHeight())
    }
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        screenTopLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        trackerCategoryTable.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        mainSpacePlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenTopLabel)
        view.addSubview(scrollView)
        view.addSubview(addCategoryButton)
        view.addSubview(mainSpacePlaceholderStack)
        scrollView.addSubview(trackerCategoryTable)
        
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
            
            
            scrollView.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -30),
            
            trackerCategoryTable.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            trackerCategoryTable.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            trackerCategoryTable.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            trackerCategoryTable.heightAnchor.constraint(equalToConstant: calculateTableHeight()),
            trackerCategoryTable.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    
    // MARK: - Methods
    private func calculateTableHeight() -> CGFloat {
        if trackersCategories.count > 1 {
            return CGFloat((trackersCategories.count * 75) - 1)
        } else if trackersCategories.count == 0 {
            return 0
        } else {
            return 74
        }
    }
    
    
    private func checkMainPlaceholderVisability() {
        let isHidden = trackersCategories.count < 1
        mainSpacePlaceholderStack.isHidden = !isHidden
    }
    
    
    @objc
    private func didTapAddCategoryButton() {
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
        trackersCategories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategorySelectionCell.identifier) as?
                CategorySelectionCell else { return UITableViewCell() }
        let categoryName = trackersCategories[indexPath.row]
        cell.configureCell(with: categoryName, isSelected: indexPath.row % 2 == 0 ? true : false)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
