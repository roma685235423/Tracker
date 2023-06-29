import Foundation

final class CategorySelectionViewModel {
    // MARK: - Public properties
    weak var delegate: CategorySelectionViewModelDelegate?
    
    // MARK: - Private properties
    private let trackerCategoryStore = TrackerCategoryStore()
    private (set) var categories: [TrackerCategory] = [] {
        didSet {
            delegate?.categoriesDidUpdate()
        }
    }
    private (set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            guard let selectedCategory = selectedCategory else { return }
            delegate?.didSelect(category: selectedCategory)
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
        categories = getCategoriesFromStore()
    }
    
    func isCheckmarkVisible(in row: Int) -> Bool {
        guard let category = selectedCategory else { return false }
        return category.id == categories[row].id ? true : false
    }
    
    func categoriesCount() -> Int {
        return categories.count
    }
    
    // MARK: - Private Methods
    private func getCategoriesFromStore() -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        categories = trackerCategoryStore.categories
        return categories
    }
}


// MARK: - TrackersCategoriesStoreDelegate
extension CategorySelectionViewModel: TrackersCategoriesStoreDelegate {
    func categoriesDidUpdate() {
        categories = trackerCategoryStore.categories
    }
}
