import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let schedule: [DayOfWeek]?
    let daysComplitedCount: Int
    let isPinned: Bool
    
    init(id: UUID = UUID(),
         label: String,
         color: UIColor,
         emoji: String,
         schedule: [DayOfWeek]?,
         daysComplitedCount: Int,
         isPinned: Bool = false
    ) {
        self.id = id
        self.label = label
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.daysComplitedCount = daysComplitedCount
        self.isPinned = isPinned
    }
}
