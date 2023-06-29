import UIKit

final class CategorySelectionCell: UITableViewCell {
    // MARK: - Puplic properties
    static let identifier = "CategoryCell"
    
    // MARK: - Private properties
    private let categoryLabel = UILabel()
    private let background = UIView()
    private let separatorView = UIView()
    private lazy var checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "check")
        imageView.frame.size = CGSize(width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addingUIElements()
        layoutConfigure()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Public Methods
    func configureCell(with text: String, isSelected: Bool, cellIndex: Int, totalRowsInTable: Int) {
        background.backgroundColor = .ypBackgroundDay
        separatorView.backgroundColor = .ypGray
        checkmarkIs(visible: !isSelected)
        configureLabel(with: text)
        
        applyCornerRadius(cellIndex: cellIndex, totalRowsInTable: totalRowsInTable)
    }
    
    func checkmarkIs(visible: Bool) {
        checkmarkImage.isHidden = visible
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        contentView.addSubview(background)
        background.addSubview(separatorView)
        contentView.addSubview(checkmarkImage)
        contentView.addSubview(categoryLabel)
    }
    
    private func layoutConfigure() {
        background.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            separatorView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20),
            
            checkmarkImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -21),
            checkmarkImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 31),
            checkmarkImage.widthAnchor.constraint(equalToConstant: 24),
            
            categoryLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            categoryLabel.rightAnchor.constraint(equalTo: checkmarkImage.leftAnchor, constant: -6),
            categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - (16 + 21 + 24))
        ])
    }
    
    private func configureLabel(with text: String) {
        categoryLabel.configureLabel(
            text: text,
            addToView: contentView,
            ofSize: 17,
            weight: .regular
        )
        categoryLabel.textAlignment = .left
    }
    
    private func applyCornerRadius(cellIndex: Int, totalRowsInTable: Int) {
        let cornerRadius: CGFloat = 16
        
        switch (cellIndex, totalRowsInTable) {
        case (0, 1):
            // Single cell in section
            separatorView.isHidden = true
            background.layer.cornerRadius = cornerRadius
            background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (0, _):
            // First cell in section
            background.layer.cornerRadius = cornerRadius
            background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (_, _) where cellIndex == totalRowsInTable - 1:
            // Last cell in section
            separatorView.isHidden = true
            background.layer.cornerRadius = cornerRadius
            background.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            // Middle cells in section
            background.layer.cornerRadius = 0
            background.layer.maskedCorners = []
        }
    }
}
