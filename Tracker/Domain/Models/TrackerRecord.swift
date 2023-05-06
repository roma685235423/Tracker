import UIKit

struct OldTrackerRecord: Hashable {
    let trackerID: UUID
    let date: Date
}


struct TrackerRecord: Hashable {
    let id: UUID
    let trackerId: UUID
    let date: Date
    
    init(id: UUID = UUID(), trackerId: UUID, date: Date) {
        self.id = id
        self.trackerId = trackerId
        self.date = date
    }
}
