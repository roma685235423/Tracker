import UIKit

final class CategoryAndSchedulerTableCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let verticalStack = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        contentView.backgroundColor = InterfaceColors.backgruondDay
        
        // Установка конфигурации стека
        verticalStack.axis = .vertical
        verticalStack.spacing = 2.0
        verticalStack.alignment = .leading
        
        // Добавление titleLabel и subTitleLabel в стек
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subTitleLabel)
        
        // Добавление стека на contentView ячейки
        contentView.addSubview(verticalStack)
        
        // Установка констрейнтов
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

    
    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        subTitleLabel.font = UIFont.systemFont(ofSize: 17)
        
        titleLabel.textColor = InterfaceColors.blackDay
        subTitleLabel.textColor = InterfaceColors.gray
        
        if subTitle.isEmpty {
            // Если subTitleLabel пустой, то установка настройки по центру titleLabel
            titleLabel.textAlignment = .center
            subTitleLabel.isHidden = true
        } else {
            // Если subTitleLabel не пустой, то установка настройки для размещения titleLabel и subTitleLabel с отступом
            titleLabel.textAlignment = .left
            subTitleLabel.isHidden = false
        }
    }
}
