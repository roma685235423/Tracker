import UIKit

var mockData: [OldTrackerCategory] = [
    OldTrackerCategory(
        title: "Домашний уют",
        trackers: [
            Tracker(
                label: "Поливать растения",
                color: cellColors[4],
                emoji: "❤️",
                dailySchedule: nil,
                scheduler: nil,
                daysComplitedCount: 0)
        ]),
    
    OldTrackerCategory(
        title: "Радостные мелочи",
        trackers: [
            Tracker(
                label: "Кошка заслонила камеру на созвоне",
                color: cellColors[1],
                emoji: "😻",
                dailySchedule: nil,
                scheduler: nil,
                daysComplitedCount: 0
            ),
            Tracker(
                label: "Бабушка прислала открытку в вотсапе",
                color: cellColors[0],
                emoji: "🌺",
                dailySchedule: nil,
                scheduler: nil,
                daysComplitedCount: 0
            ),
            Tracker(
                label: "Свидания в апреле",
                color: cellColors[13],
                emoji: "❤️",
                dailySchedule: nil,
                scheduler: nil,
                daysComplitedCount: 0
            )
        ])
]
