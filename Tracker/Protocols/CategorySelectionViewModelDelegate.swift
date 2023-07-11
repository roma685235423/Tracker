import Foundation

protocol CategorySelectionViewModelDelegate: AnyObject {
    func categoriesDidUpdate()
    func categoryDidSelect()
    func add(newCategory: TrackerCategory)
}
