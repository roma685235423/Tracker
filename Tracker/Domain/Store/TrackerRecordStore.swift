import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    // MARK: - Errors
    enum CategoryStoreError: Error {
        case decodeError
    }
    
    // MARK: - Public properties
    weak var delegate: TrackerRecordStoreDelegate?
    
    // MARK: - Private properties
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()
    private var completedTrackers: Set<TrackerRecord> = []
    
    // MARK: - Life cicle
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public methods
    func completedTrackers(by date: Date) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate)
        let recordsCoreData = try context.fetch(request)
        let records = try recordsCoreData.map { try createTrackerRecord(from: $0) }
        completedTrackers = Set(records)
        delegate?.didUpdate(records: completedTrackers)
    }
    
    func add(record: TrackerRecord) throws {
        let trackerCoreData = try trackerStore.getTrackerFromCoreData(id: record.trackerId)
        let trackerRecordFromCoreData = TrackerRecordCoreData(context: context)
        trackerRecordFromCoreData.recordId = record.id.uuidString
        trackerRecordFromCoreData.date = record.date
        trackerRecordFromCoreData.tracker = trackerCoreData
        try context.save()
        completedTrackers.insert(record)
        delegate?.didUpdate(records: completedTrackers)
    }
    
    func remove(record: TrackerRecord) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.recordId), record.id.uuidString
        )
        let records = try context.fetch(request)
        guard let recordToRemove = records.first else { return }
        context.delete(recordToRemove)
        try context.save()
        completedTrackers.remove(record)
        delegate?.didUpdate(records: completedTrackers)
    }
    
    // MARK: - Private methods
    private func createTrackerRecord(from coreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let idString = coreData.recordId,
            let id = UUID(uuidString: idString),
            let date = coreData.date,
            let trackerCoreData = coreData.tracker,
            let tracker = try? trackerStore.createTracker(from: trackerCoreData)
        else
        { throw CategoryStoreError.decodeError }
        
        return TrackerRecord(id: id, trackerId: tracker.id, date: date)
    }
}
