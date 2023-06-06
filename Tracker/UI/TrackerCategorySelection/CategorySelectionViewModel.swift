import Foundation

typealias Binding<T> = (T) -> Void

final class CategorySelectionViewModel {
//    private let trackerCategoryStore = TrackerCategoryStore()
    var selectedCategory: Binding<TrackerCategory>?
    
    private let model: CategorySelectionModel
    
    init(for model: CategorySelectionModel) {
        self.model = model
    }
//    func getCategoriesFromStore() -> [TrackerCategory] {
//
//        return trackerCategoryStore.categories
//    }
//
//    func getCategoriesCount() -> Int {
//        trackerCategoryStore.categories.count
//    }
//
//    func calculateTableSize() -> CGFloat {
//        if trackerCategoryStore.categories.count > 1 {
//            return CGFloat((trackerCategoryStore.categories.count * 75) - 1)
//        } else if trackerCategoryStore.categories.count == 0 {
//            return 0
//        } else {
//            return 74
//        }
//    }
}
