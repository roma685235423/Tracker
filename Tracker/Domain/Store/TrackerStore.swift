import UIKit
import CoreData


final class TrackerStore: NSObject {
    // MARK: - Properties
    private let context: NSManagedObjectContext
    
    private let colorMarshalling = UIColorMarshalling()
    
    
    // MARK: - Init
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
}
