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
    private let categoresStore = TrackerCategoryStore()
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
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    
    // MARK: - Methods
    func createTracker(from coreData: TrackerCoreData) throws -> Tracker {
        guard let idString = coreData.trackerId,
              let id = UUID(uuidString: idString),
              let label = coreData.label,
              let emoji = coreData.emoji,
              let colorHEX = coreData.colorHEX
        else { throw CategoryStoreError.decodeError }
        let color = colorFromHEX(colorHEX)
        let schedule = scheduleFromCoreData(coreData)
        return Tracker(
            id: id,
            label: label,
            color: color,
            emoji: emoji,
            schedule: schedule,
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
    
    
    func getTrackerAt(indexPath: IndexPath) -> Tracker? {
        let trackerFromCoreData = fetchedResultsController.object(at: indexPath)
        guard let idString = trackerFromCoreData.trackerId,
              let id = UUID(uuidString: idString),
              let label = trackerFromCoreData.label,
              let emoji = trackerFromCoreData.emoji,
              let colorHEX = trackerFromCoreData.colorHEX else { return nil }
        let schedule = scheduleFromCoreData(trackerFromCoreData)
        let color = colorFromHEX(colorHEX)
        return Tracker(
            id: id,
            label: label,
            color: color,
            emoji: emoji,
            schedule: schedule,
            daysComplitedCount: 0
        )
    }
    
    
    func getFilteredTrackers(searchedText: String, date: Date) throws {
        let dayOfWeekIndex = Calendar.current.component(.weekday, from: date)
        let iso860DayOfWeekIndex = dayOfWeekIndex > 1 ? dayOfWeekIndex - 2 : dayOfWeekIndex + 5
        let regex = createWeekdayRegex(iso860DayOfWeekIndex)
        let schedulePredicate = createSchedulePredicate(regex)
        let searchPredicate = createSearchPredicate(searchedText)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [schedulePredicate, searchPredicate])
        fetchedResultsController.fetchRequest.predicate = compoundPredicate
        
        try fetchedResultsController.performFetch()
        delegate?.updateTracker()
    }
    
    
    private func createWeekdayRegex(_ iso860DayOfWeekIndex: Int) -> String {
        var weekdayPattern = ""
        for index in 0..<7 {
            if index == iso860DayOfWeekIndex {
                weekdayPattern += "1"
            } else {
                weekdayPattern += "."
            }
        }
        return weekdayPattern
    }
    
    
    private func createSchedulePredicate(_ weekdayPattern: String) -> NSPredicate {
        return NSPredicate(format: "%K == nil OR (%K != nil AND %K MATCHES[c] %@)",
                           #keyPath(TrackerCoreData.schedule),
                           #keyPath(TrackerCoreData.schedule),
                           #keyPath(TrackerCoreData.schedule), weekdayPattern)
    }
    
    
    private func createSearchPredicate(_ searchedText: String) -> NSPredicate {
        return NSPredicate(format: "%K CONTAINS[cd] %@",
                           #keyPath(TrackerCoreData.label), searchedText)
    }
    
    
    func addTracker(tracker: Tracker, with category: TrackerCategory) throws {
        let categoryCoreData = try categoresStore.getCategoryFromCoreData(id: category.id)
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.createdAt = Date()
        trackerCoreData.colorHEX = colorMarshalling.hexString(from: tracker.color)
        trackerCoreData.schedule = DayOfWeek.dayCodeString(from: tracker.schedule)
        trackerCoreData.category = categoryCoreData
        trackerCoreData.trackerId = tracker.id.uuidString
        trackerCoreData.label = tracker.label
        trackerCoreData.emoji = tracker.emoji
        try context.save()
    }
    
    
    private func colorFromHEX(_ hexString: String) -> UIColor {
        return colorMarshalling.color(from: hexString)
    }
    
    private func colorToHEX(_ color: UIColor) -> String {
        return colorMarshalling.hexString(from: color)
    }
    
    private func scheduleFromCoreData(_ coreData: TrackerCoreData) -> [DayOfWeek]? {
        return DayOfWeek.decodeFrom(dayCodeString: coreData.schedule)
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
