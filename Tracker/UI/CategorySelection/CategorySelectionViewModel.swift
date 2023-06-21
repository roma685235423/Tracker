import Foundation

protocol CategorySelectionViewModelDelegate: AnyObject {
    func categoriesDidUpdate()
    func didSelect(category: TrackerCategory)
}

final class CategorySelectionViewModel {
    // MARK: - Properties
    
    weak var delegate: CategorySelectionViewModelDelegate?
    
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
    
    // MARK: - Initialization
    
    init(for selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
        trackerCategoryStore.delegate = self
    }
    
    
    // MARK: - Public Methods
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
