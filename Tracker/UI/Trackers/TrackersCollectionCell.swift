import UIKit

final class TrackersCollectionCell: UICollectionViewCell {
    // MARK: - Public properties
    weak var delegate: TrackersCollectinCellDelegate?
    
    // MARK: - Private properties
    private let trackerBackgroundView = UIView()
    private let emojieLabel = UILabel()
    private let trackerTextLabel = UILabel()
    private let counterLabel = UILabel()
    private let taskIsDoneButton = UIButton()
    private let pinImage = UIImageView()
    
    private var tracker: Tracker?
    private let analyticsService = AnalyticsService()
    
    private let spaceFromEdge: CGFloat = 12
    private var daysCounter = 0 {
        willSet {
            counterLabel.text = "\(getCorrectRussianWordDay(days: newValue))"
        }
    }
    
    static let identifier = "TrackersCollectionCell"
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
    func configureCellContent(
        prototype: Tracker,
        daysCounter: Int,
        isDone: Bool,
        isPinned: Bool,
        userInteraction: UIContextMenuInteraction
    ) {
        self.tracker = prototype
        self.daysCounter = daysCounter
        trackerBackgroundView.addInteraction(userInteraction)
        configureBackground(color: prototype.color)
        configureEmojiLabel(with: prototype.emoji)
        configureTextLabel(with: prototype.label)
        configureTaskIsDoneButton(color: prototype.color)
        configureCounterLabel()
        pinImageVisibitity(isVisible: isPinned)
        setTaskIsDoneButton(equalTo: isDone)
        configurePinImage()
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
    
    func pinImageVisibitity(isVisible: Bool) {
        pinImage.isHidden = !isVisible
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        [trackerBackgroundView, counterLabel, taskIsDoneButton, ].forEach{
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [emojieLabel, trackerTextLabel, pinImage].forEach{
            trackerBackgroundView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            trackerBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            trackerBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            trackerBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            trackerBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            
            emojieLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spaceFromEdge),
            emojieLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            emojieLabel.heightAnchor.constraint(equalToConstant: 24),
            emojieLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackerTextLabel.bottomAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: -spaceFromEdge),
            trackerTextLabel.leadingAnchor.constraint(equalTo: trackerBackgroundView.leadingAnchor, constant: spaceFromEdge),
            trackerTextLabel.trailingAnchor.constraint(equalTo: trackerBackgroundView.trailingAnchor, constant: -spaceFromEdge),
            
            taskIsDoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spaceFromEdge),
            taskIsDoneButton.topAnchor.constraint(equalTo: trackerBackgroundView.bottomAnchor, constant: 8),
            taskIsDoneButton.heightAnchor.constraint(equalToConstant: 34),
            taskIsDoneButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterLabel.centerYAnchor.constraint(equalTo: taskIsDoneButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            counterLabel.trailingAnchor.constraint(equalTo: taskIsDoneButton.leadingAnchor, constant: -8),
            
            pinImage.heightAnchor.constraint(equalToConstant: 12),
            pinImage.widthAnchor.constraint(equalToConstant: 8),
            pinImage.centerYAnchor.constraint(equalTo: emojieLabel.centerYAnchor),
            pinImage.rightAnchor.constraint(equalTo: trackerBackgroundView.rightAnchor, constant: -12)
        ])
    }
    
    private func getCorrectRussianWordDay(days: Int) -> String {
        let formatString : String = NSLocalizedString(
            "number of days",
            comment: "Days count string format to be found in Localized.stringsdict"
        )
        let daysCounterString = String.localizedStringWithFormat(
            formatString,
            days
        )
        return daysCounterString
    }
    
    private func configureCounterLabel() {
        counterLabel.textAlignment = .left
        counterLabel.font = UIFont.systemFont(ofSize: 12)
        counterLabel.textColor = .ypBlack
        counterLabel.text = getCorrectRussianWordDay(days: daysCounter)
    }
    
    private func configurePinImage() {
        pinImage.image = UIImage(systemName: "pin.fill")
        pinImage.tintColor = .ypWhiteDay
    }
    
    private func configureBackground(color: UIColor) {
        self.contentView.layer.cornerRadius = 16
        trackerBackgroundView.layer.cornerRadius = 16
        trackerTextLabel.layer.borderWidth = 1
        trackerBackgroundView.layer.masksToBounds = true
        
        trackerBackgroundView.backgroundColor = color
        trackerBackgroundView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
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
            addToView: trackerBackgroundView,
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
        taskIsDoneButton.tintColor = .ypWhite
        taskIsDoneButton.addTarget(self, action: #selector(didTapTaskIsDoneButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func didTapTaskIsDoneButton() {
        guard let tracker else { return }
        analyticsService.report(event: "click", params: [
            "screen": "Main",
            "item": "track"
        ])
        
        delegate?.didTapTaskIsDoneButton(cell: self, tracker: tracker)
    }
}
