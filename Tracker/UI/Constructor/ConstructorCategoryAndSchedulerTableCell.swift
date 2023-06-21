import UIKit

final class CategoryAndSchedulerTableCell: UITableViewCell {
    // MARK: - UI
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let verticalStack = UIStackView()
    
    
    // MARK: - Methods
    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        subTitleLabel.font = UIFont.systemFont(ofSize: 17)
        
        titleLabel.textColor = InterfaceColors.blackDay
        subTitleLabel.textColor = InterfaceColors.gray
        titleLabel.textAlignment = .left
        
        subTitleLabel.isHidden = subTitle.isEmpty ? true : false
    }
    
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.backgroundColor = InterfaceColors.backgruondDay
        
        verticalStack.axis = .vertical
        verticalStack.spacing = 2.0
        verticalStack.alignment = .leading
        
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subTitleLabel)
        
        contentView.addSubview(verticalStack)
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 14)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
