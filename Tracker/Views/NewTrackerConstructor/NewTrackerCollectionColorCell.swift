import UIKit

final class CollectionColorCell: UICollectionViewCell {
    private let framelabel = UILabel()
    private let colorLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(framelabel)
        contentView.addSubview(colorLabel)
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        framelabel.translatesAutoresizingMaskIntoConstraints = false
        framelabel.layer.cornerRadius = 52/5
        framelabel.layer.borderWidth = 3
        framelabel.layer.borderColor = UIColor.clear.cgColor
        colorLabel.layer.cornerRadius = 8
        colorLabel.layer.masksToBounds = true
        framelabel.layer.masksToBounds = true
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCellColor(color: UIColor) {
        self.colorLabel.backgroundColor = color
    }
    
    func cellIsSelected(state: Bool) {
        if state == true {
            framelabel.layer.borderColor = InterfaceColors.gray.cgColor
        } else {
            framelabel.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
