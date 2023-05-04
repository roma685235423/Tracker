import UIKit
import CoreData


final class TrackerCategoryStore: NSObject {
    // MARK: - Properties
    var categories = [TrackerCategory]()
    
    private let context: NSManagedObjectContext
    
    
    // MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
    }
}
