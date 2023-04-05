import UIKit

final class ScheduleViewController: UIViewController {
    private let screenTopLabel = UILabel()
    private let schedulerTable = UITableView()
    private lazy var readyButton = UIButton()
    private var dailySchedule: [IsScheduleActiveToday]
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    var scheduleViewControllerCallback: (([IsScheduleActiveToday], String) -> Void)?
    
    private func initialSettings() {
        view.backgroundColor = InterfaceColors.whiteDay
        screenTopLabel.configureLabel(
            text: "Расписание",
            addToView: view,
            ofSize: 16,
            weight: .medium
        )
        configureschedulerTable()
        configureReadyButton()
        setConstraints()
    }
    
    
    private func configureschedulerTable() {
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
        readyButton.addTarget(self, action: #selector(bibTapReadyButton), for: .touchUpInside)
    }
    
    private func setConstraints() {
        screenTopLabel.translatesAutoresizingMaskIntoConstraints = false
        schedulerTable.translatesAutoresizingMaskIntoConstraints = false
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(screenTopLabel)
        view.addSubview(schedulerTable)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            screenTopLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            screenTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            schedulerTable.topAnchor.constraint(equalTo: screenTopLabel.bottomAnchor, constant: 38),
            schedulerTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            schedulerTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            schedulerTable.heightAnchor.constraint(equalToConstant: 524),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    init(dailySchedule: [IsScheduleActiveToday]) {
         self.dailySchedule = dailySchedule
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailySchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(dailySchedule[indexPath.row].schedulerIsActive, animated: true)
        switchView.tag = indexPath.row
        switchView.onTintColor = InterfaceColors.blue
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.textLabel?.text = dailySchedule[indexPath.row].dayOfWeek
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
    
    private func shortWeekDaysNamesCreation() -> String {
        var shortDaysOfWeekNames: [String] = []
        for day in dailySchedule {
            if day.schedulerIsActive {
                if let shortDayName = weekDaysNamesShorting(day: day.dayOfWeek) {
                    shortDaysOfWeekNames.append(shortDayName)
                }
            }
        }
        let shortDaysOfWeekNamesString = shortDaysOfWeekNames.joined(separator: ", ")
        return shortDaysOfWeekNamesString
    }
    
    func weekDaysNamesShorting(day: String?) -> String? {
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
    
    @objc
    private func switchChanged(_ sender : UISwitch!){
        let row = sender.tag
        dailySchedule[row].schedulerIsActive.toggle()
    }
    
    @objc
    private func bibTapReadyButton() {
        scheduleViewControllerCallback?(dailySchedule, shortWeekDaysNamesCreation())
        self.dismiss(animated: true)
    }
}
