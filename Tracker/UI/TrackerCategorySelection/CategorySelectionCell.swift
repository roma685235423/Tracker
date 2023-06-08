import UIKit


final class CategorySelectionCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "CategoryCell"
    private let categoryLabel = UILabel()
    
    private lazy var checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "checkmark")
        imageView.frame.size = CGSize(width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private func configureLabel(with text: String) {
        categoryLabel.configureLabel(
            text: text,
            addToView: contentView,
            ofSize: 17,
            weight: .regular
        )
        categoryLabel.textAlignment = .left
    }
    
    func configureCell(with text: String, isSelected: Bool) {
        contentView.backgroundColor = InterfaceColors.backgruondDay
        
        checkmarkImage.isHidden = !isSelected
        contentView.addSubview(checkmarkImage)
        contentView.addSubview(categoryLabel)
        configureLabel(with: text)
        
        NSLayoutConstraint.activate([
            checkmarkImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -21),
            checkmarkImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 31),
            checkmarkImage.widthAnchor.constraint(equalToConstant: 24),
            
            categoryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            categoryLabel.rightAnchor.constraint(equalTo: checkmarkImage.leftAnchor, constant: -6),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - (16 + 21 + 24))
        ])
    }
}
