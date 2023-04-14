import UIKit

var mockData: [TrackerCategory] = [
    TrackerCategory(
        title: "Домашний уют",
        trackers: [
            Tracker(
                label: "Поливать растения",
                color: cellColors[4],
                emoji: "❤️",
                dailySchedule: nil)
        ]),
    
    TrackerCategory(
        title: "Радостные мелочи",
        trackers: [
            Tracker(
                label: "Кошка заслонила камеру на созвоне",
                color: cellColors[1],
                emoji: "😻",
                dailySchedule: nil
            ),
            Tracker(
                label: "Бабушка прислала открытку в вотсапе",
                color: cellColors[0],
                emoji: "🌺",
                dailySchedule: nil
            ),
            Tracker(
                label: "Свидания в апреле",
                color: cellColors[13],
                emoji: "❤️",
                dailySchedule: nil
            )
        ])
]
