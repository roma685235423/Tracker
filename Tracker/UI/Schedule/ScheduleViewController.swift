import UIKit

final class ScheduleViewController: UIViewController {
    // MARK: - Public properties
    var scheduleVCCallback: (([DayOfWeek], String) -> Void)?
    
    // MARK: - Private properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: tableHeight + buttonHeight + (spacing * 2))
        return scrollView
    }()
    private lazy var schedulerTable: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .ypGray
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var readyButton: UIButton = {
        let button = UIButton(label: NSLocalizedString("schedule.ready", comment: ""))
        button.addTarget(self, action: #selector(didTapReadyButton), for: .touchUpInside)
        return button
    }()
    private let weekDaysForTable = DayOfWeek.allCases
    private let tableHeight = CGFloat(524)
    private let buttonHeight = CGFloat(60)
    
    private var spacing = CGFloat()
    private var daysOfWeekForSceduler: [DayOfWeek]
    
    // MARK: - Life cicle
    init(daysInScedule: [DayOfWeek]) {
        self.daysOfWeekForSceduler = daysInScedule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        spacing = self.view.frame.height * 0.0458
        addingUIElements()
        configurenavigationController()
        layoutConfigure()
    }
    
    // MARK: - Private methods
    private func addingUIElements() {
        [scrollView, schedulerTable, readyButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func layoutConfigure() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
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
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        scrollView.layoutIfNeeded()
    }
    
    private func configurenavigationController() {
        title = NSLocalizedString("schedule.title", comment: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlack
        ]
    }
    
    private func shortWeekDaysNamesCreation() -> String {
        var shortDaysOfWeekNames: [String] = []
        for day in daysOfWeekForSceduler {
            shortDaysOfWeekNames.append(day.localizedStringShort)
        }
        if shortDaysOfWeekNames.count < 7 {
            let result = daysOfWeekForSceduler.isEmpty ? "" : shortDaysOfWeekNames.joined(separator: ", ")
            return result
        } else {
            return NSLocalizedString("schedule.everyDay", comment: "")
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
        dismiss(animated: true)
    }
}


// MARK: - UITableViewDataSource Extension
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDaysForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
        let currentDay = weekDaysForTable[indexPath.row].localizedString
        let isSwitchOn = daysOfWeekForSceduler.first{$0.localizedString == currentDay} != nil
        
        switchView.setOn(isSwitchOn, animated: true)
        switchView.tag = indexPath.row
        switchView.onTintColor = .ypBlue
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        switchView.backgroundColor = .ypSwitchBackground
        switchView.layer.cornerRadius = switchView.frame.height / 2
        
        cell.textLabel?.text = currentDay
        cell.textLabel?.textColor = .ypBlack
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.accessoryView = switchView
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
