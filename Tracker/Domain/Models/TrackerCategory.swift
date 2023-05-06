import UIKit

struct OldTrackerCategory {
    let title: String
    let trackers: [Tracker]
}


struct TrackerCategory {
    let title: String
    let id: UUID
    
    init(title: String, id: UUID = UUID()) {
        self.title = title
        self.id = id
    }
}
