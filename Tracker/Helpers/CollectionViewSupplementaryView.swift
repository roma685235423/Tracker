import UIKit

final class SupplementaryView: UICollectionReusableView {
    // MARK: - Public properties
    var titleLabel = UILabel()
    
    // MARK: - Life cicle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func configoreLayout(leftOffset: CGFloat, topOffset: CGFloat, bottomOffset: CGFloat) {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftOffset),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: topOffset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomOffset),
        ])
    }
}
