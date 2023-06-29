import UIKit

final class CollectionColorCell: UICollectionViewCell {
    // MARK: - Private properties
    private let framelabel = UILabel()
    private let colorLabel = UILabel()
    
    // MARK: - Life cicle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(framelabel)
        contentView.addSubview(colorLabel)
        
        configureColorLabel()
        configureFrameLabel()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func setCellColor(color: UIColor) {
        self.colorLabel.backgroundColor = color
    }
    
    func cellIsSelected(state: Bool) {
        if state == true {
            let color = colorLabel.backgroundColor
            framelabel.layer.borderColor = color?.withAlphaComponent(0.3).cgColor
        } else {
            framelabel.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Private methods
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            framelabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            framelabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            framelabel.heightAnchor.constraint(equalToConstant: 52),
            framelabel.widthAnchor.constraint(equalToConstant: 52),
            
            colorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorLabel.heightAnchor.constraint(equalToConstant: 40),
            colorLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureColorLabel() {
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.layer.cornerRadius = 8
        colorLabel.layer.masksToBounds = true
    }
    
    private func configureFrameLabel() {
        framelabel.translatesAutoresizingMaskIntoConstraints = false
        framelabel.layer.cornerRadius = 52/5
        framelabel.layer.borderWidth = 3
        framelabel.layer.borderColor = UIColor.clear.cgColor
        framelabel.layer.masksToBounds = true
    }
}
