import UIKit

final class TrackersCollectionCell: UICollectionViewCell {
    // MARK: - Public properties
    weak var delegate: TrackersCollectinCellDelegate?
    
    // MARK: - Private properties
    private let trackerBackgroundLabel = UILabel()
    private let emojieLabel = UILabel()
    private let trackerTextLabel = UILabel()
    private let counterLabel = UILabel()
    private let taskIsDoneButton = UIButton()
    
    private var tracker: Tracker?
    
    private let spaceFromEdge: CGFloat = 12
    private var daysCounter = 0 {
        willSet {
            counterLabel.text = "\(getCorrectRussianWordDay(days: newValue))"
        }
    }
    
    // MARK: - Life cicle
    override init(frame: CGRect) {
        super.init(frame: frame)
        tracker = nil
        addingUIElements()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        setTaskIsDoneButton(equalTo: false)
        daysCounter = 0
    }
    
    // MARK: - Public methods
    func configureCellContent(prototype: Tracker, daysCounter: Int, isDone: Bool) {
        self.tracker = prototype
        self.daysCounter = daysCounter
        configureBackground(color: prototype.color)
        configureEmojiLabel(with: prototype.emoji)
        configureTextLabel(with: prototype.label)
        configureTaskIsDoneButton(color: prototype.color)
        configureCounterLabel()
        setTaskIsDoneButton(equalTo: isDone)
    }
    
    func setTaskIsDoneButton(equalTo: Bool) {
        if equalTo {
            taskIsDoneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            taskIsDoneButton.layer.opacity = 0.3
        } else {
            taskIsDoneButton.setImage(UIImage(systemName: "plus"), for: .normal)
            taskIsDoneButton.layer.opacity = 1
        }
    }
    
    func counterAdd() {
        daysCounter += 1
    }
    
    func counterSub() {
        daysCounter -= 1
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        [trackerBackgroundLabel, emojieLabel, trackerTextLabel, counterLabel, taskIsDoneButton].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            trackerBackgroundLabel.topAnchor.constraint(equalTo: self.topAnchor),
            trackerBackgroundLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            trackerBackgroundLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            trackerBackgroundLabel.heightAnchor.constraint(equalToConstant: 90),
            
            emojieLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spaceFromEdge),
            emojieLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            emojieLabel.heightAnchor.constraint(equalToConstant: 24),
            emojieLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackerTextLabel.bottomAnchor.constraint(equalTo: trackerBackgroundLabel.bottomAnchor, constant: -spaceFromEdge),
            trackerTextLabel.leadingAnchor.constraint(equalTo: trackerBackgroundLabel.leadingAnchor, constant: spaceFromEdge),
            trackerTextLabel.trailingAnchor.constraint(equalTo: trackerBackgroundLabel.trailingAnchor, constant: -spaceFromEdge),
            
            taskIsDoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spaceFromEdge),
            taskIsDoneButton.topAnchor.constraint(equalTo: trackerBackgroundLabel.bottomAnchor, constant: 8),
            taskIsDoneButton.heightAnchor.constraint(equalToConstant: 34),
            taskIsDoneButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterLabel.centerYAnchor.constraint(equalTo: taskIsDoneButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            counterLabel.trailingAnchor.constraint(equalTo: taskIsDoneButton.leadingAnchor, constant: -8)
        ])
    }
    
    private func getCorrectRussianWordDay(days: Int) -> String {
        let mod10 = days % 10
        let mod100 = days % 100
        switch mod10 {
        case 1 where mod100 != 11:
            return "\(days) день"
        case 2...4 where mod100 < 12 || mod100 > 14:
            return "\(days) дня"
        default:
            return "\(days) дней"
        }
    }
    
    private func configureCounterLabel() {
        counterLabel.textAlignment = .left
        counterLabel.font = UIFont.systemFont(ofSize: 12)
        counterLabel.textColor = .ypBlackDay
        counterLabel.text = getCorrectRussianWordDay(days: daysCounter)
    }
    
    private func configureBackground(color: UIColor) {
        trackerBackgroundLabel.layer.cornerRadius = 16
        trackerTextLabel.layer.borderWidth = 1
        trackerBackgroundLabel.layer.masksToBounds = true
        
        trackerBackgroundLabel.backgroundColor = color
        trackerBackgroundLabel.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    private func configureEmojiLabel(with emoji: String) {
        emojieLabel.frame.size = CGSize(width: 24, height: 24)
        emojieLabel.layer.cornerRadius =  emojieLabel.layer.frame.height/2
        emojieLabel.layer.masksToBounds = true
        
        emojieLabel.backgroundColor = .ypWhiteDay.withAlphaComponent(0.3)
        emojieLabel.font = UIFont.systemFont(ofSize: 13)
        emojieLabel.text = emoji
        emojieLabel.textAlignment = .center
    }
    
    private func configureTextLabel(with text: String) {
        trackerTextLabel.configureLabel(
            text: text,
            addToView: trackerBackgroundLabel,
            ofSize: 12,
            weight: .medium
        )
        trackerTextLabel.textAlignment = .left
        trackerTextLabel.numberOfLines = 0
        trackerTextLabel.layer.borderColor = UIColor.clear.cgColor
        trackerTextLabel.textColor = .ypWhiteDay
    }
    
    private func configureTaskIsDoneButton(color: UIColor) {
        taskIsDoneButton.frame.size = CGSize(width: 34, height: 34)
        taskIsDoneButton.layer.cornerRadius =  taskIsDoneButton.layer.frame.height/2
        taskIsDoneButton.layer.masksToBounds = true
        
        taskIsDoneButton.backgroundColor = color
        taskIsDoneButton.setImage(UIImage(systemName: "plus"), for: .normal)
        taskIsDoneButton.tintColor = .ypWhiteDay
        taskIsDoneButton.addTarget(self, action: #selector(didTapTaskIsDoneButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func didTapTaskIsDoneButton() {
        guard let tracker else { return }
        delegate?.didTapTaskIsDoneButton(cell: self, tracker: tracker)
    }
}
