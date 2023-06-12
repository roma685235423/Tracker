import Foundation


protocol CategorySelectionViewModelProtocol: AnyObject {
    func categoriesDidUpdate()
    func didSelect(category: TrackerCategory)
}



final class CategorySelectionViewModel {
    weak var delegate: CategorySelectionViewModelProtocol?
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private (set) var categoies: [TrackerCategory] = [] {
        didSet {
            delegate?.categoriesDidUpdate()
        }
    }
    
    private (set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            guard let selectedCategory else { return }
            delegate?.didSelect(category: selectedCategory)
        }
    }
    
    
    init(for selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
        trackerCategoryStore.delegate = self
    }
    
    func getCategoriesStringsFromStore() -> [String] {
        var stringCategories: [String] = []
        for category in trackerCategoryStore.categories {
            stringCategories.append(category.title)
        }
        return stringCategories
    }
    
    func getCategoriesFromStore() -> [TrackerCategory] {
        var categories: [TrackerCategory] = []
        categories = trackerCategoryStore.categories
        return categories
    }
    
    func loadCategories() {
        categoies = getCategoriesFromStore()
    }
    
    func isCheckmarkVisible(in row: Int) -> Bool {
        guard let category = selectedCategory else { return false }
        return category.id == categoies[row].id ? true : false
    }
}


extension CategorySelectionViewModel: TrackersCategoriesStoreDelegate {
    func categoriesDidUpdate() {
        categoies = trackerCategoryStore.categories
    }
}
