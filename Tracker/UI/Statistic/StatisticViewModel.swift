import Foundation

final class StatisticsViewModel {
    // MARK: - Public properties
    var statisticVCCallback: (([TrackerRecord]) -> Void)?
    
    // MARK: - Private properties
    private let trackerRecordStore = TrackerRecordStore()
    private var trackers: [TrackerRecord] = [] {
        didSet {
            statisticVCCallback?(trackers)
        }
    }
    
    // MARK: - Public methods
    func viewWillAppear() {
        guard let trackers = try? trackerRecordStore.getCompletedTrackers() else { return }
        self.trackers = trackers
    }
}
