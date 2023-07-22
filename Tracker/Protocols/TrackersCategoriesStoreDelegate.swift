import Foundation

protocol TrackersCategoriesStoreDelegate: AnyObject {
    func categoriesDidUpdate(update: CategoryStoreUpdates)
}
