import UIKit


final class CategorySelectionCell: UITableViewCell {
    
    private let categoryLabel = UILabel()
    private let checkmarkImage = UIImage()
    
    func configureLabel(with text: String) {
        categoryLabel.configureLabel(
            text: text,
            addToView: contentView,
            ofSize: 17,
            weight: .regular
        )
    }
}
