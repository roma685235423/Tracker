import UIKit

final class TrackerFilteringViewController: UIViewController {
    //MARK: - Private properties
    private let tableView = UITableView()
    private let filters = [
    NSLocalizedString("filters.all", comment: ""),
    NSLocalizedString("filters.today", comment: ""),
    NSLocalizedString("filters.completed", comment: ""),
    NSLocalizedString("filters.notCompleted", comment: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        layoutConfigure()
        configurenavigationController()
        configureTableView()
    }
    private func layoutConfigure() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        
        tableView.register(
            TableViewCellWithBlueCheckmark.self,
            forCellReuseIdentifier: TableViewCellWithBlueCheckmark.identifier
        )
        tableView.layer.cornerRadius = 16
        tableView.tableHeaderView = UIView(
            frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 1)
        )
        tableView.tableHeaderView?.backgroundColor = .ypWhite
    }
    
    private func configurenavigationController() {
        title = NSLocalizedString("filters", comment: "")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
            .foregroundColor: UIColor.ypBlack
        ]
    }
}

extension TrackerFilteringViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellWithBlueCheckmark.identifier, for: indexPath) as?
        TableViewCellWithBlueCheckmark else {fatalError("Invalid cell configuration")}
        cell.configureCell(
            with: filters[indexPath.row],
            isSelected: false,
            cellIndex: indexPath.row,
            totalRowsInTable: filters.count
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}
