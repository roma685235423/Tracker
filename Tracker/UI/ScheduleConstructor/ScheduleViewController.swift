import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - UIElements
    private let scrollView = UIScrollView()
    private let screenTopLabel = UILabel()
    private let schedulerTable = UITableView()
    private lazy var readyButton = UIButton()
    
    // MARK: - Properties
    private let weekDaysStringForTable = DayOfWeek.allCases.map { $0.rawValue }
    private var daysOfWeekForSceduler: [DayOfWeek]
    
    var scheduleVCCallback: (([DayOfWeek], String) -> Void)?
    
    private let tableHeight = CGFloat(524)
    private let buttonHeight = CGFloat(60)
    private var spacing = CGFloat()
    
    
    
    // MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    
    // MARK: - Layout configuraion
    private func configureLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        schedulerTable.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(schedulerTable)
        scrollView.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.0515),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: view.frame.height * 0.0744),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            schedulerTable.topAnchor.constraint(equalTo: scrollView.topAnchor),
            schedulerTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            schedulerTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            schedulerTable.heightAnchor.constraint(equalToConstant: tableHeight),
            
            
            readyButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.topAnchor.constraint(equalTo: schedulerTable.bottomAnchor, constant: spacing)
        ])
        scrollView.layoutIfNeeded()
    }
    
    
    // MARK: - UIConfiguration methods
    private func initialSettings() {
        view.backgroundColor = InterfaceColors.whiteDay
        spacing = self.view.frame.height * 0.0458
        screenTopLabel.configureLabel(
            text: "Расписание",
            addToView: view,
            ofSize: 16,
            weight: .medium
        )
        configureScrollView()
        configureSchedulerTable()
        configureReadyButton()
        configureLayout()
    }
    
    
    private func configureScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: tableHeight + buttonHeight + (spacing * 2))
    }
    
    
    private func configureSchedulerTable() {
        schedulerTable.delegate = self
        schedulerTable.dataSource = self
        schedulerTable.separatorColor = InterfaceColors.gray
        schedulerTable.layer.cornerRadius = 16
        schedulerTable.layer.masksToBounds = true
        schedulerTable.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        schedulerTable.isScrollEnabled = false
    }
    
    
    private func configureReadyButton() {
        readyButton.backgroundColor = InterfaceColors.blackDay
        readyButton.setTitle("Готово", for: .normal)
        readyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        readyButton.titleLabel?.textColor = InterfaceColors.whiteDay
        readyButton.layer.cornerRadius = 16
        readyButton.layer.masksToBounds = true
        readyButton.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
    }
    
    
    // MARK: - Methods
    private func shortWeekDaysNamesCreation() -> String {
        var shortDaysOfWeekNames: [String] = []
        for day in daysOfWeekForSceduler {
            if let shortDayName = weekDaysNamesShorting(day: day.rawValue) {
                shortDaysOfWeekNames.append(shortDayName)
            }
        }
        if shortDaysOfWeekNames.count < 7 {
            let result = daysOfWeekForSceduler.isEmpty ? "" : shortDaysOfWeekNames.joined(separator: ", ")
            return result
        } else {
            return "Каждый день"
        }
    }
    
    
    private func weekDaysNamesShorting(day: String?) -> String? {
        switch day {
        case "Понедельник":
            return "Пн"
        case "Вторник":
            return "Вт"
        case "Среда":
            return "Ср"
        case "Четверг":
            return "Чт"
        case "Пятница":
            return "Пт"
        case "Суббота":
            return "Сб"
        case "Воскресенье":
            return "Вс"
        default :
            return nil
        }
    }
    
    
    private func getDayOfWeek(at row: Int) -> DayOfWeek? {
        guard let dayOfWeek = DayOfWeek.allCases[safe: row] else {
            return nil
        }
        let changedDayOfWeek = dayOfWeek
        return changedDayOfWeek
    }
    
    
    
    private func changeSceduler(day: DayOfWeek?) {
        guard let changedDay = day else { return }
        if daysOfWeekForSceduler.contains(changedDay) {
            guard let index = daysOfWeekForSceduler.firstIndex(of: changedDay) else { return }
            daysOfWeekForSceduler.remove(at: index)
        } else {
            daysOfWeekForSceduler.append(changedDay)
            sortDaysOfWeekForSceduler()
        }
    }
    
    
    private func sortDaysOfWeekForSceduler() {
        if daysOfWeekForSceduler.count > 1 {
            daysOfWeekForSceduler.sort { (day1, day2) -> Bool in
                guard let index1 = DayOfWeek.allCases.firstIndex(of: day1),
                      let index2 = DayOfWeek.allCases.firstIndex(of: day2) else {
                    return false
                }
                return index1 < index2
            }
        }
    }
    
    
    // MARK: - Actions
    @objc
    private func switchChanged(_ sender : UISwitch!) {
        let row = sender.tag
        let changedDay = getDayOfWeek(at: row)
        changeSceduler(day: changedDay)
    }
    
    
    @objc
    private func didTapReadyButton() {
        scheduleVCCallback?(daysOfWeekForSceduler, shortWeekDaysNamesCreation())
        self.dismiss(animated: true)
    }
    
    
    // MARK: - init
    init(daysOfWeekForSceduler: [DayOfWeek]) {
        self.daysOfWeekForSceduler = daysOfWeekForSceduler
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK: - UITableViewDelegate Extension
extension ScheduleViewController: UITableViewDelegate {
    
}



// MARK: - UITableViewDataSource Extension
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDaysStringForTable.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
        let currentDay = weekDaysStringForTable[indexPath.row]
        let isSwitchOn = daysOfWeekForSceduler.first{$0.rawValue == currentDay} != nil
        
        switchView.setOn(isSwitchOn, animated: true)
        switchView.tag = indexPath.row
        switchView.onTintColor = InterfaceColors.blue
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        
        cell.textLabel?.text = currentDay
        cell.textLabel?.textColor = InterfaceColors.blackDay
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.accessoryView = switchView
        cell.selectionStyle = .none
        cell.backgroundColor = InterfaceColors.backgruondDay
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
