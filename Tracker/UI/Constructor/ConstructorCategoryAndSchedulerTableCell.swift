import UIKit

final class CategoryAndSchedulerTableCell: UITableViewCell {
    
    // MARK: Private properties
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.backgroundColor = .ypBackground
        configureStackView()
        addingUIElements()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods

extension CategoryAndSchedulerTableCell {
    
    func configure(title: String, subTitle: String) {
        configureTitleLabel(with: title)
        configureSubitleLabel(with: subTitle)
    }
}

// MARK: - Private methods

private extension CategoryAndSchedulerTableCell {
    
    func addingUIElements() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        contentView.addSubview(stackView)
    }
    
    func layoutConfigure() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 14)
        ])
    }
    
    func configureTitleLabel(with text: String) {
        titleLabel.text = text
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .ypBlack
        titleLabel.textAlignment = .left
    }
    
    func configureSubitleLabel(with text: String) {
        subTitleLabel.text = text
        subTitleLabel.font = UIFont.systemFont(ofSize: 17)
        subTitleLabel.textColor = .ypGray
        subTitleLabel.isHidden = text.isEmpty ? true : false
    }
    
    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2.0
        stackView.alignment = .leading
    }
}
