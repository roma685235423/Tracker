import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    // MARK: - Errors
    enum CategoryStoreError: Error {
        case decodeError
    }
    
    // MARK: - Private properties
    weak var delegate: TrackersCategoriesStoreDelegate?
    lazy var categories: [TrackerCategory] = {
        do {
            let request = TrackerCategoryCoreData.fetchRequest()
            let result = try context.fetch(request)
            let resultArray = try result.map { try createCategory(from: $0) }
            return resultArray
        } catch {
            return []
        }
    }()
    private let context: NSManagedObjectContext
    
    // MARK: - Life cicle
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        try setupMockCategories(with: context)
    }
    
    // MARK: - Public method
    func getCategoryFromCoreData(id: UUID) throws -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
        let category = try context.fetch(request).first
        return category
    }
    
    // MARK: - Private methods
    private func createCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let idString = coreData.categoryId,
              let title = coreData.label,
              let id = UUID(uuidString: idString)
        else { throw CategoryStoreError.decodeError}
        return TrackerCategory(title: title, id: id)
    }
    
    private func setupMockCategories(with context: NSManagedObjectContext) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(request)
        
        guard result.isEmpty else {
            categories = try result.map { try createCategory(from: $0) }
            return
        }
        let _ = [
            TrackerCategory(title: "Домашний уют"),
            TrackerCategory(title: "Радостные мелочи"),
            TrackerCategory(title: "Самочувствие"),
            TrackerCategory(title: "Привычки"),
            TrackerCategory(title: "Внимательность"),
            TrackerCategory(title: "Спорт"),
            TrackerCategory(title: "Игры"),
            TrackerCategory(title: "Учёба"),
            TrackerCategory(title: "Работа"),
            TrackerCategory(title: "Медитации")
        ].map { category in
            let categoryFromCoreData = TrackerCategoryCoreData(context: context)
            categoryFromCoreData.categoryId = category.id.uuidString
            categoryFromCoreData.createdAt = Date()
            categoryFromCoreData.label = category.title
            return categoryFromCoreData
        }
        try context.save()
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.categoriesDidUpdate()
    }
}
