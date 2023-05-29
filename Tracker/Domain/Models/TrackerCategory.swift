import UIKit


struct TrackerCategory {
    let title: String
    let id: UUID
    
    init(title: String, id: UUID = UUID()) {
        self.title = title
        self.id = id
    }
}
