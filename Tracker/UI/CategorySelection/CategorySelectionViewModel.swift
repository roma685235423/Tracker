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
            print(categories)
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
    func printCategoryes() {
        print(categories)
    }
    func isCategoriesExist() -> Bool {
        return categoriesCount() > 0
    }
    
    func selectCategory(row: Int) {
        selectedCategory = categories[row]
    }
    
    func loadCategories() {
        categories = trackerCategoryStore.getCategoryesFromStore()
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
}


// MARK: - TrackersCategoriesStoreDelegate
extension CategorySelectionViewModel: TrackersCategoriesStoreDelegate {
    func categoriesDidUpdate(update: CategoryStoreUpdates) {
        categories = trackerCategoryStore.getCategoryesFromStore()
        updateVMCallback?(update)
    }
}
