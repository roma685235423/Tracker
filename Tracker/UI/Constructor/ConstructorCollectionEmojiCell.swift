import UIKit

final class CollectionEmojiCell: UICollectionViewCell {
    // MARK: - UI
    private let framelabel = UILabel()
    private let emojiLabel = UILabel()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureEmojiLabel()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func cellIsSelected(state: Bool) {
        if state == true {
            contentView.backgroundColor = .ypLightGray
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    func setEmojieLabel(emojie: String) {
        emojiLabel.text = emojie
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configureEmojiLabel() {
        contentView.addSubview(emojiLabel)
        emojiLabel.font = UIFont.systemFont(ofSize: 32)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureContentView() {
        contentView.layer.cornerRadius = 52/5
        contentView.layer.masksToBounds = true
    }
}
