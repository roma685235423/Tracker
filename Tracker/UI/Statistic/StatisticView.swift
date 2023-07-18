import UIKit

final class StatisticsView: UIView {
    // MARK: - Private properties
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    private var name: String {
        didSet {
            nameLabel.text = name
        }
    }
    private var number: Int {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    
    // MARK: - Life Cycle
    required init(number: Int = 0, name: String) {
        self.number = number
        self.name = name
        
        super.init(frame: .zero)
        
        setNumber(number)
        setName(name)
        addingUIElements()
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }
    
    // MARK: - Public methods
    func setNumber(_ number: Int) {
        self.number = number
    }
    
    func setName(_ name: String) {
        self.name = name
    }
    
    // MARK: - Layout Configuration
    func addingUIElements() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberLabel)
        addSubview(nameLabel)
    }
    
    func layoutConfigure() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            nameLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: numberLabel.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    func setupBorder() {
        createGradientBorder(
            width: 1,
            cornerRadius: 12,
            colors: UIColor.gradientColors,
            startPoint: CGPoint(x: 1.0, y: 0.5),
            endPoint: CGPoint(x: 0.0, y: 0.5)
        )
    }
}
