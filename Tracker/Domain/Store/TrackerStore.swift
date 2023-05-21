import UIKit
import CoreData


protocol TrackerStoreDelegate: AnyObject {
    func updateTracker()
}


final class TrackerStore: NSObject {
    // MARK: - Errors
    enum CategoryStoreError: Error {
        case decodeError
    }
    
    // MARK: - Properties
    weak var delegate: TrackerStoreDelegate?
    
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
    
    var numberOfTrackers: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.categoryId, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.createdAt, ascending: true)
        ]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    
    // MARK: - Methods
    func createTracker(from coreData: TrackerCoreData) throws -> Tracker {
        guard
            let idString = coreData.trackerId,
            let id = UUID(uuidString: idString),
            let label = coreData.label,
            let emoji = coreData.emoji,
            let colorHEX = coreData.colorHEX
        else { throw CategoryStoreError.decodeError }
        let color = colorMarshalling.color(from: colorHEX)
        return Tracker(
            id: id,
            label: label,
            color: color,
            emoji: emoji,
            dailySchedule: [],
            schedule: nil,
            daysComplitedCount: 0
        )
    }
    
    
    func getTrackerFromCoreData(id: UUID) throws -> TrackerCoreData? {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId), id.uuidString
        )
        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func getHeaderLabelFor(section: Int) -> String? {
        guard
            let trackerCoreData = fetchedResultsController.sections?[section].objects?.first as? TrackerCoreData
        else { return nil }
        return trackerCoreData.category?.label ?? nil
    }
    
    
//    func getTrackerAt(indexPath: IndexPath) -> Tracker? {
//        let trackerFromCoreData = fetchedResultsController.object(at: indexPath)
//        do {
//            let tracker = try createTracker(from: trackerFromCoreData)
//            return tracker
//        } catch {
//            return nil
//        }
//    }
    
    
    func getTrackerAt(indexPath: IndexPath) -> Tracker? {
        let trackerFromCoreData = fetchedResultsController.object(at: indexPath)
        guard let idString = trackerFromCoreData.trackerId,
              let id = UUID(uuidString: idString),
              let label = trackerFromCoreData.label,
              let emoji = trackerFromCoreData.emoji,
              let colorHEX = trackerFromCoreData.colorHEX else {
                  return nil
              }
        let color = colorMarshalling.color(from: colorHEX)
        return Tracker(
            id: id,
            label: label,
            color: color,
            emoji: emoji,
            dailySchedule: [],
            schedule: nil,
            daysComplitedCount: 0
        )
    }
    
    
    func addTracker(tracker: Tracker, with category: TrackerCategory) throws {
        let categoryCoreData = try categoryStore.getCategoryFromCoreData(id: category.id)
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.createdAt = Date()
        trackerCoreData.colorHEX = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.schedule = DayOfWeek.code(tracker.schedule)
        trackerCoreData.category = categoryCoreData
        trackerCoreData.trackerId = tracker.id.uuidString
        trackerCoreData.label = tracker.label
        trackerCoreData.emoji = tracker.emoji
        try context.save()
    }
    
    
    // MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateTracker()
    }
}
