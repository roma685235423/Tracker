import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let dailySchedule: [DailySchedule]?
    var daysComplitedCount: Int = 0
    
    init(id: UUID = UUID(), label: String, color: UIColor, emoji: String, dailySchedule: [DailySchedule]?) {
        self.id = id
        self.label = label
        self.color = color
        self.emoji = emoji
        self.dailySchedule = dailySchedule
    }
}
