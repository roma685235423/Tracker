import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let schedule: [DayOfWeek]?
    let daysComplitedCount: Int
    
    init(id: UUID = UUID(),
         label: String,
         color: UIColor,
         emoji: String,
         schedule: [DayOfWeek]?,
         daysComplitedCount: Int) {
        self.id = id
        self.label = label
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.daysComplitedCount = daysComplitedCount
    }
}
