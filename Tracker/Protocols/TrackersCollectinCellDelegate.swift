import Foundation

protocol TrackersCollectinCellDelegate: AnyObject {
    func didTapTaskIsDoneButton(cell: TrackersCollectionCell, tracker: Tracker)
}
