import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: UIColor
    let emoji: String
    let schedule: [DayOfWeek]?
    let daysComplitedCount: Int
    let isPinned: Bool
    let category: TrackerCategory
    
    init(id: UUID = UUID(),
         label: String,
         color: UIColor,
         emoji: String,
         schedule: [DayOfWeek]?,
         daysComplitedCount: Int,
         isPinned: Bool = false,
         category: TrackerCategory
    ) {
        self.id = id
        self.label = label
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.daysComplitedCount = daysComplitedCount
        self.isPinned = isPinned
        self.category = category
    }
    
    init(tracker: Tracker) {
        self.id = tracker.id
        self.label = tracker.label
        self.emoji = tracker.emoji
        self.color = tracker.color
        self.category = tracker.category
        self.daysComplitedCount = tracker.daysComplitedCount
        self.schedule = tracker.schedule
        self.isPinned = tracker.isPinned
    }
    
    init(values: Values) {
        guard
            let emoji = values.emoji,
            let color = values.color,
            let category = values.category
        else { fatalError() }
        
        self.id = UUID()
        self.label = values.label
        self.emoji = emoji
        self.color = color
        self.category = category
        self.daysComplitedCount = values.daysComplitedCount
        self.schedule = values.schedule
        self.isPinned = values.isPinned
    }
    
    var values: Values {
        Values(
            label: label,
            emoji: emoji,
            color: color,
            category: category,
            daysComplitedCount: daysComplitedCount,
            schedule: schedule
        )
    }
}

extension Tracker {
    struct Values {
        var label: String = ""
        var emoji: String? = nil
        var color: UIColor? = nil
        var category: TrackerCategory? = nil
        var daysComplitedCount: Int = 0
        var schedule: [DayOfWeek]? = nil
        var isPinned: Bool = false
    }
}
