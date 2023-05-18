import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let dailySchedule: [DailySchedule]?
    /// УДАЛИТЬ==================================================================
    let scheduler: [DayOfWeek]?
    /// УДАЛИТЬ==================================================================
    let daysComplitedCount: Int
    
    init(id: UUID = UUID(),
         label: String,
         color: UIColor,
         emoji: String,
         /// УДАЛИТЬ==================================================================
         dailySchedule: [DailySchedule]?,
         /// УДАЛИТЬ==================================================================
         scheduler: [DayOfWeek]?,
         daysComplitedCount: Int) {
        self.id = id
        self.label = label
        self.color = color
        self.emoji = emoji
        /// УДАЛИТЬ==================================================================
        self.dailySchedule = dailySchedule
        /// УДАЛИТЬ==================================================================
        self.scheduler = scheduler
        self.daysComplitedCount = daysComplitedCount
    }
}
