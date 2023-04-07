import UIKit

final class TrackersCollectinCell: UICollectionViewCell {
    private let trackerBackgroundLabel = UILabel()
    private let emojieLabel = UILabel()
    private let trackerTextLabel = UILabel()
    private let daysCounterTextLabel = UILabel()
    private let taskIsDoneButton = UIButton()
    
    private let spaceFromEdge: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCellContent(prototype: Tracker) {
        trackerBackgroundLabel.backgroundColor = prototype.color
        trackerBackgroundLabel.layer.borderColor = prototype.color.withAlphaComponent(0.3).cgColor
    
        emojieLabel.backgroundColor = prototype.color.withAlphaComponent(0.3)
        emojieLabel.font = UIFont.systemFont(ofSize: 16)
        emojieLabel.text = prototype.emoji
        
        taskIsDoneButton.backgroundColor = prototype.color
    }
    
    
    private func configureLayout() {
        contentView.addSubview(trackerBackgroundLabel)
        contentView.addSubview(emojieLabel)
        contentView.addSubview(trackerTextLabel)
        contentView.addSubview(daysCounterTextLabel)
        contentView.addSubview(taskIsDoneButton)
        
        trackerBackgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        emojieLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerTextLabel.translatesAutoresizingMaskIntoConstraints = false
        daysCounterTextLabel.translatesAutoresizingMaskIntoConstraints = false
        taskIsDoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        trackerBackgroundLabel.layer.cornerRadius = 16
        trackerTextLabel.layer.borderWidth = 1
        
        emojieLabel.frame.size = CGSize(width: 24, height: 24)
        emojieLabel.layer.cornerRadius =  emojieLabel.layer.frame.height/2
        
        taskIsDoneButton.frame.size = CGSize(width: 34, height: 34)
        taskIsDoneButton.layer.cornerRadius =  taskIsDoneButton.layer.frame.height/2
        
        trackerBackgroundLabel.layer.masksToBounds = true
        emojieLabel.layer.masksToBounds = true
        taskIsDoneButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            trackerBackgroundLabel.topAnchor.constraint(equalTo: self.topAnchor),
            trackerBackgroundLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            trackerBackgroundLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            trackerBackgroundLabel.heightAnchor.constraint(equalToConstant: 90),
            
            emojieLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spaceFromEdge),
            emojieLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            
            trackerTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: spaceFromEdge),
            trackerTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            trackerTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spaceFromEdge),
            
            taskIsDoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spaceFromEdge),
            taskIsDoneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: spaceFromEdge),
            taskIsDoneButton.topAnchor.constraint(equalTo: trackerBackgroundLabel.bottomAnchor, constant: 8),
            
            daysCounterTextLabel.centerYAnchor.constraint(equalTo: taskIsDoneButton.centerYAnchor),
            daysCounterTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            daysCounterTextLabel.trailingAnchor.constraint(equalTo: taskIsDoneButton.leadingAnchor, constant: -8)
        ])
    }
}
