import Foundation

final class CategorySelectionViewModel {
    // MARK: - Public properties
    weak var delegate: CategorySelectionViewModelDelegate?
    
    // MARK: - Private properties
    var updateVMCallback: ((CategoryStoreUpdates) -> Void)?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private (set) var categories: [TrackerCategory] = [] {
        didSet {
            delegate?.categoriesDidUpdate()
        }
    }
    private (set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            if selectedCategory != nil {
                delegate?.categoryDidSelect()
            } else { return }
        }
    }
    
    // MARK: - Life cicle
    init(for selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
        trackerCategoryStore.delegate = self
    }
    
    
    // MARK: - Public Methods
    func isCategoriesExist() -> Bool {
        return categoriesCount() > 0
    }
    
    func selectCategory(row: Int) {
        selectedCategory = categories[row]
    }
    
    func loadCategories() {
        categories = sortCategoryes()
    }
    
    func isCheckmarkVisible(in row: Int) -> Bool {
        guard let category = selectedCategory else { return false }
        return category.id == categories[row].id ? true : false
    }
    
    func categoriesCount() -> Int {
        return categories.count
    }
    
    func add(newCategory: TrackerCategory) {
        do {
            try trackerCategoryStore.add(newCategory: newCategory)
            loadCategories()
        } catch {
            
        }
    }
    
    private func sortCategoryes() -> [TrackerCategory] {
        categories = trackerCategoryStore.getCategoryesFromStore()
        return categories.sorted(by: { $0.title < $1.title })
    }
}

// MARK: - TrackersCategoriesStoreDelegate
extension CategorySelectionViewModel: TrackersCategoriesStoreDelegate {
    func categoriesDidUpdate(update: CategoryStoreUpdates) {
        categories = trackerCategoryStore.getCategoryesFromStore()
        updateVMCallback?(update)
    }
}
