import Foundation


@objcMembers
final class CategorySelectionModel: NSObject, Identifiable {
    let id: String
    private(set) dynamic var emojis: String
    //private(set) dynamic var size: String

    init(id: String, emojis: String) {
        self.id = id
        self.emojis = emojis
        super.init()
    }
}
