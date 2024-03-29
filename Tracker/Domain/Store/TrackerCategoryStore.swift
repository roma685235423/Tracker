import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    
    // MARK: Public properties
    
    weak var delegate: TrackersCategoriesStoreDelegate?
    
    // MARK: Private properties
    
    private let context: NSManagedObjectContext
    private var newIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    
    // MARK: Lifecycle
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
    
    // MARK: Public method
    
    func getCategoryFromCoreData(id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
        let category = try context.fetch(request)
        return category[0]
    }
    
    func add(newCategory: TrackerCategory) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.categoryId = newCategory.id.uuidString
        categoryCoreData.createdAt = Date()
        categoryCoreData.label = newCategory.title
        
        try context.save()
    }
    
    func getCategoryesFromStore() -> [TrackerCategory]{
        do {
            let request = TrackerCategoryCoreData.fetchRequest()
            let result = try context.fetch(request)
            let resultArray = try result.map { try createCategory(from: $0) }
            return resultArray
        } catch {
            return []
        }
    }
    
    func createCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let idString = coreData.categoryId,
              let title = coreData.label,
              let id = UUID(uuidString: idString)
        else { throw CategoryStoreError.decodeError}
        return TrackerCategory(title: title, id: id)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.categoriesDidUpdate(
            update: CategoryStoreUpdates(
                newIndexes: newIndexes,
                deletedIndexes: deletedIndexes
            )
        )
        resetIndexes()
    }
}

// MARK: - Private methods

private extension TrackerCategoryStore {
    func resetIndexes() {
        newIndexes = []
        deletedIndexes = []
    }
}
