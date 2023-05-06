import UIKit
import CoreData


final class TrackerCategoryStore: NSObject {
    enum CategoryStoreError: Error {
        case decodeError
    }
    
    // MARK: - Properties
    var categories = [TrackerCategory]()
    
    private let context: NSManagedObjectContext
    
    
    // MARK: - Methods
    func getCategoryFromCoreData(id: UUID) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryId), id.uuidString)
        let category = try context.fetch(request)
        return category[0]
    }
    
    
    private func createCategory(from coreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let idString = coreData.categoryId,
              let label = coreData.label,
              let id = UUID(uuidString: idString)
        else { throw CategoryStoreError.decodeError}
        return TrackerCategory(title: label, id: id)
    }
    
    
    private func setupCategories(with context: NSManagedObjectContext) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(request)
        
        guard result.count == 0 else {
            categories = try result.map({ try createCategory(from: $0) })
            return
        }
        
        let _ = [
            TrackerCategory(title: "Домашний уют"),
            TrackerCategory(title: "Радостные мелочи")
        ].map { category in
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.createdAt = Date()
            categoryCoreData.label = category.title
            categoryCoreData.categoryId = category.id.uuidString
            return categoryCoreData
        }
        try context.save()
    }
    
    // MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
}
