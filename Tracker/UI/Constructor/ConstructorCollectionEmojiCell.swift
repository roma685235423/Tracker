import UIKit

final class CollectionEmojiCell: UICollectionViewCell {
    
    // MARK:  Private properties
    
    private let emojiLabel = UILabel()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureEmojiLabel()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods

extension CollectionEmojiCell {
    
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
}

// MARK: - Private methods

private extension CollectionEmojiCell {
    
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
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
}
