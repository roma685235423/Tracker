import Foundation

final class CategorySelectionModel: NSObject, Identifiable {
    let id: String
    private(set) dynamic var category: String

    init(id: String, category: String) {
        self.id = id
        self.category = category
        super.init()
    }
}
