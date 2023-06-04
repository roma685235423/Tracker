import UIKit


// MARK: - TrackersCollectinCellDelegate
protocol TrackersCollectinCellDelegate: AnyObject {
    func didTapTaskIsDoneButton(cell: TrackersCollectionCell, tracker: Tracker)
}


// MARK: - TrackersCollectinCell
final class TrackersCollectionCell: UICollectionViewCell {
    // MARK: - UI
    private let trackerBackgroundLabel = UILabel()
    private let emojieLabel = UILabel()
    private let trackerTextLabel = UILabel()
    private let daysCounterTextLabel = UILabel()
    private let taskIsDoneButton = UIButton()
    private var tracker: Tracker?
    
    
    // MARK: - Properties
    weak var delegate: TrackersCollectinCellDelegate?
    private let spaceFromEdge: CGFloat = 12
    private var daysCounter = 0 {
        willSet {
            daysCounterTextLabel.text = "\(getCorrectRussianWordDay(days: newValue))"
        }
    }
    
    
    // MARK: - Life cicle
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        changeTaskIsDoneButtonUI(state: false)
        daysCounter = 0
    }
    
    
    // MARK: - Layout configuraion
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
            emojieLabel.heightAnchor.constraint(equalToConstant: 24),
            emojieLabel.widthAnchor.constraint(equalToConstant: 24),
            
            trackerTextLabel.bottomAnchor.constraint(equalTo: trackerBackgroundLabel.bottomAnchor, constant: -spaceFromEdge),
            trackerTextLabel.leadingAnchor.constraint(equalTo: trackerBackgroundLabel.leadingAnchor, constant: spaceFromEdge),
            trackerTextLabel.trailingAnchor.constraint(equalTo: trackerBackgroundLabel.trailingAnchor, constant: -spaceFromEdge),
            
            taskIsDoneButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -spaceFromEdge),
            taskIsDoneButton.topAnchor.constraint(equalTo: trackerBackgroundLabel.bottomAnchor, constant: 8),
            taskIsDoneButton.heightAnchor.constraint(equalToConstant: 34),
            taskIsDoneButton.widthAnchor.constraint(equalToConstant: 34),
            
            daysCounterTextLabel.centerYAnchor.constraint(equalTo: taskIsDoneButton.centerYAnchor),
            daysCounterTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: spaceFromEdge),
            daysCounterTextLabel.trailingAnchor.constraint(equalTo: taskIsDoneButton.leadingAnchor, constant: -8)
        ])
    }
    
    
    // MARK: - Methods
    func configureCellContent(prototype: Tracker, daysCounter: Int, isDone: Bool) {
        self.tracker = prototype
        self.daysCounter = daysCounter
        trackerBackgroundLabel.backgroundColor = prototype.color
        trackerBackgroundLabel.layer.borderColor = prototype.color.withAlphaComponent(0.3).cgColor
        
        emojieLabel.backgroundColor = InterfaceColors.whiteDay.withAlphaComponent(0.3)
        emojieLabel.font = UIFont.systemFont(ofSize: 13)
        emojieLabel.text = prototype.emoji
        emojieLabel.textAlignment = .center
        
        trackerTextLabel.configureLabel(
            text: prototype.label,
            addToView: trackerBackgroundLabel,
            ofSize: 12,
            weight: .medium
        )
        trackerTextLabel.textAlignment = .left
        trackerTextLabel.numberOfLines = 0
        trackerTextLabel.layer.borderColor = UIColor.clear.cgColor
        
        trackerTextLabel.textColor = InterfaceColors.whiteDay
        
        taskIsDoneButton.backgroundColor = prototype.color
        taskIsDoneButton.setImage(UIImage(systemName: "plus"), for: .normal)
        taskIsDoneButton.tintColor = InterfaceColors.whiteDay
        taskIsDoneButton.addTarget(self, action: #selector(didTapTaskIsDoneButton), for: .touchUpInside)
        
        daysCounterTextLabel.textAlignment = .left
        daysCounterTextLabel.font = UIFont.systemFont(ofSize: 12)
        daysCounterTextLabel.textColor = InterfaceColors.blackDay
        daysCounterTextLabel.text = getCorrectRussianWordDay(days: daysCounter)
        changeTaskIsDoneButtonUI(state: isDone)
    }
    
    
    func changeTaskIsDoneButtonUI(state: Bool) {
        if state {
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
    
    
    // MARK: - Actions
    @objc
    private func didTapTaskIsDoneButton() {
        guard let tracker else { return }
        delegate?.didTapTaskIsDoneButton(cell: self, tracker: tracker)
    }
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        tracker = nil
        configureLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
