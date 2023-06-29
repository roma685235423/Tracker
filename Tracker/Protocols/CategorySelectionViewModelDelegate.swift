import Foundation

protocol CategorySelectionViewModelDelegate: AnyObject {
    func categoriesDidUpdate()
    func didSelect(category: TrackerCategory)
}
