import UIKit

final class CollectionEmojiCell: UICollectionViewCell {
    // MARK: - UI
    private let framelabel = UILabel()
    private let emojiLabel = UILabel()
    
    
    // MARK: - Methods
    func cellIsSelected(state: Bool) {
        if state == true {
            contentView.backgroundColor = InterfaceColors.lightGray
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    func setEmojieLabel(emojie: String) {
        emojiLabel.text = emojie
    }
    
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 52/5
        contentView.layer.masksToBounds = true
        emojiLabel.font = UIFont.systemFont(ofSize: 32)
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
