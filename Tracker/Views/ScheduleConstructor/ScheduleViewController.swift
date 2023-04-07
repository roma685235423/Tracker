import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let screenTopLabel = UILabel()
    private let schedulerTable = UITableView()
    private lazy var readyButton = UIButton()
    private var dailySchedule: [IsScheduleActiveToday]
    var scheduleVCCallback: (([IsScheduleActiveToday], String) -> Void)?
    
    
    private let tableHeight = CGFloat(524)
    private let buttonHeight = CGFloat(60)
    private var spacing = CGFloat()
    
    // MARK: - Lifi cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    
    // MARK: - Methods
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
        let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
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
    
    
    @objc
    private func switchChanged(_ sender : UISwitch!){
        let row = sender.tag
        dailySchedule[row].schedulerIsActive.toggle()
    }
    
    
    @objc
    private func didTapReadyButton() {
        scheduleVCCallback?(dailySchedule, shortWeekDaysNamesCreation())
        self.dismiss(animated: true)
    }
}
