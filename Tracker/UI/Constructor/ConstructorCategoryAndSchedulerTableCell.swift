import UIKit

final class CategoryAndSchedulerTableCell: UITableViewCell {
    // MARK: - UI
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Life cicle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        self.backgroundColor = InterfaceColors.backgruondDay
        configureStackView()
        addingUIElements()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout configuraion
    private func addingUIElements() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        contentView.addSubview(stackView)
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 14)
        ])
    }
    
    // MARK: - Helpers
    func configure(title: String, subTitle: String) {
        configureTitleLabel(with: title)
        configureSubitleLabel(with: subTitle)
    }
    
    private func configureTitleLabel(with text: String) {
        titleLabel.text = text
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = InterfaceColors.blackDay
        titleLabel.textAlignment = .left
    }
    
    private func configureSubitleLabel(with text: String) {
        subTitleLabel.text = text
        subTitleLabel.font = UIFont.systemFont(ofSize: 17)
        subTitleLabel.textColor = InterfaceColors.gray
        subTitleLabel.isHidden = text.isEmpty ? true : false
    }
    
    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2.0
        stackView.alignment = .leading
    }
}
