import UIKit
import CoreData

final class TrackerStore: NSObject {
    // MARK: - Errors
    enum CategoryStoreError: Error {
        case decodeError, fetchTrackerError, deleteError, pinError
    }
    
    // MARK: - Public properties
    var numberOfTrackers: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    var numberOfSections: Int {
        sections.count
    }
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - Private properties
    private let categoresStore = TrackerCategoryStore()
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarshalling()
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
    private var pinnedTrackers: [Tracker] {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else { return [] }
        let trackers = fetchedObjects.compactMap { try? createTracker(from:$0) }
        return trackers.filter({ $0.isPinned })
    }
    private var sections: [[Tracker]] {
        guard let sectionsFromCoreData = fetchedResultsController.sections else { return [] }
        var sections: [[Tracker]] = []
        
        if !pinnedTrackers.isEmpty {
            sections.append(pinnedTrackers)
        }
        
        sectionsFromCoreData.forEach { section in
            var sectionToAdd = [Tracker]()
            section.objects?.forEach({ object in
                guard
                    let trackerCoreData = object as? TrackerCoreData,
                    let tracker = try? createTracker(from: trackerCoreData),
                    !pinnedTrackers.contains(where: { $0.id == tracker.id })
                else { return }
                sectionToAdd.append(tracker)
            })
            if !sectionToAdd.isEmpty {
                sections.append(sectionToAdd)
            }
        }
        return sections
    }
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
    func numberOfRowsInSection(_ section: Int) -> Int {
        sections[section].count
    }
    
    func createTracker(from coreData: TrackerCoreData) throws -> Tracker {
        guard let idString = coreData.trackerId,
              let id = UUID(uuidString: idString),
              let label = coreData.label,
              let emoji = coreData.emoji,
              let colorHEX = coreData.colorHEX,
              let complitedDaysCounter = coreData.records,
              let categoryCoreData = coreData.category,
              let category = try? categoresStore.createCategory(from: categoryCoreData)
        else { throw CategoryStoreError.decodeError }
        let color = colorFromHEX(colorHEX)
        let schedule = scheduleFromCoreData(coreData)
        
        return Tracker(
            id: id,
            label: label,
            color: color,
            emoji: emoji,
            schedule: schedule,
            daysComplitedCount: complitedDaysCounter.count,
            isPinned: coreData.isPinned,
            category: category
        )
    }
    func tracker(at indexPath: IndexPath) -> Tracker? {
        let tracker = sections[indexPath.section][indexPath.item]
        return tracker
    }
    
    func getTrackerFromCoreData(id: UUID) throws -> TrackerCoreData? {
        let fetchRequest = fetchedResultsController.fetchRequest
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId), id.uuidString
        )
        try fetchedResultsController.performFetch()
        return fetchedResultsController.fetchedObjects?.first
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        sections[section].count
    }
    
    func getLabelFor(section: Int) -> String? {
        var sectionTitles = [String]()
        var trackersLabels = [String]()
        if !pinnedTrackers.isEmpty {
            sectionTitles.append("Закрепленные")
        }
        for section in sections {
            trackersLabels = []
            for tracker in section {
                if !tracker.isPinned {
                    trackersLabels.append(tracker.label)
                }
            }
            if !trackersLabels.isEmpty {
                guard let sectionLabel = section.first?.category.title else { return nil }
                if !sectionTitles.contains(sectionLabel) {
                    sectionTitles.append(sectionLabel)
                }
            }
        }
        let result = section == sectionTitles.count ? "" : sectionTitles[section]
        return result
    }
    
    func getTrackerAt(indexPath: IndexPath) -> Tracker? {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        do {
            let tracker = try createTracker(from: trackerCoreData)
            return tracker
        } catch {
            return nil
        }
    }
    
    func getFilteredTrackers( date: Date, searchedText: String) throws {
        var predicates = [NSPredicate]()
        let dayOfWeekIndex = Calendar.current.component(.weekday, from: date)
        let iso860DayOfWeekIndex = dayOfWeekIndex > 1 ? dayOfWeekIndex - 2 : dayOfWeekIndex + 5
        let regex = createWeekdayRegex(iso860DayOfWeekIndex)
        predicates.append(createSchedulePredicate(regex))
        
        if searchedText.isEmpty == false {
            predicates.append(createSearchPredicate(searchedText))
        }
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchedResultsController.fetchRequest.predicate = compoundPredicate
        
        try fetchedResultsController.performFetch()
        delegate?.updateTrackers()
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
        trackerCoreData.isPinned = false
        try context.save()
    }
    
    func editTracker(tracker: Tracker, with values: Tracker.Values) throws {
        guard
            let emoji = values.emoji,
            let color = values.color,
            let category = values.category
        else { return }
        
        let trackerCoreData = try getTrackerCoreData(by: tracker.id)
        let categoryCoreData = try categoresStore.getCategoryFromCoreData(id: category.id)
        trackerCoreData?.colorHEX = colorMarshalling.hexString(from: color)
        trackerCoreData?.schedule = DayOfWeek.dayCodeString(from: values.schedule)
        trackerCoreData?.category = categoryCoreData
        trackerCoreData?.label = values.label
        trackerCoreData?.emoji = emoji
        try context.save()
    }
    
    func deleteTracker(_ tracker: Tracker) throws {
        guard let trackerToDelete = try getTrackerCoreData(by: tracker.id) else { throw CategoryStoreError.deleteError }
        context.delete(trackerToDelete)
        try context.save()
    }
    
    func togglePin(for tracker: Tracker) throws {
        guard let trackerToToggle = try getTrackerCoreData(by: tracker.id) else { throw CategoryStoreError.pinError }
        trackerToToggle.isPinned.toggle()
        try context.save()
    }
    
    // MARK: - Private methods
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
        return NSPredicate(
            format: "%K == nil OR (%K != nil AND %K MATCHES[c] %@)",
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule),
            #keyPath(TrackerCoreData.schedule), weekdayPattern
        )
    }
    
    private func createSearchPredicate(_ searchedText: String) -> NSPredicate {
        return NSPredicate(format: "%K CONTAINS[cd] %@",
                           #keyPath(TrackerCoreData.label), searchedText)
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
    
    func getTrackerCoreData(by id: UUID) throws -> TrackerCoreData? {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerCoreData.trackerId), id.uuidString
        )
        try fetchedResultsController.performFetch()
        guard let tracker = fetchedResultsController.fetchedObjects?.first else { throw CategoryStoreError.fetchTrackerError }
        fetchedResultsController.fetchRequest.predicate = nil
        try fetchedResultsController.performFetch()
        return tracker
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updateTrackers()
    }
}
