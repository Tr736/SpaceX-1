import UIKit

final class RocketListViewController: UIViewController {
    // Mark: - Properties

    private enum Constants {
        static let estimateRowHeight: CGFloat = 200
    }

    private enum AccessibilityIdentifiers {
        static let viewId = "RocketListView"
        static let tableViewId = "RocketListTableView"
    }

    private let viewModel: RocketListViewModel?
    private var dataSource: RocketListDataSource?

    // MARK: - Views
    private lazy var rocketListView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityLabel = AccessibilityIdentifiers.tableViewId
        view.estimatedRowHeight = Constants.estimateRowHeight
        view.rowHeight = UITableView.automaticDimension
        view.register(RocketListTableViewCell.self,
                      forCellReuseIdentifier: RocketListTableViewCell.identifier)
        view.backgroundColor = .clear
        view.tableFooterView = UIView()
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        return view
    }()

    // MARK: - View Lifecycle
    init(viewModel: RocketListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
        assertionFailure("RocketListViewController does not support XIB or Storyboard")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareDataSource()
        fetchList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    private func prepareView() {
        guard rocketListView.superview === nil else { return }
        view.addSubview(rocketListView)
        NSLayoutConstraint.activate([
            rocketListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rocketListView.topAnchor.constraint(equalTo: view.topAnchor),
            rocketListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rocketListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func prepareDataSource() {
        viewModel?.set(tableView: rocketListView, delegate: self)
    }
 // MARK: - Network Calls
    private func fetchList() {
        viewModel?.fetchList().done({ success in
            if !success {
                // TODO: Try again logic and display error
            }
        })
    }
}
// MARK: - RocketListDataSourceDelegate
extension RocketListViewController: RocketListDataSourceDelegate {
    func didSelect(item: RocketListData) {
        viewModel?.viewDetail(data: item)
    }
}
