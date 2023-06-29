import Foundation

protocol TrackerRecordStoreDelegate: AnyObject {
    func didUpdate(records: Set<TrackerRecord>)
}
