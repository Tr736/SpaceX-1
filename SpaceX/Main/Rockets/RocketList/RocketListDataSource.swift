import Foundation
import UIKit

protocol RocketListDataSourceType {
    var delegate: RocketListDataSourceDelegate? { get set }
    func update(data: [RocketListData])
}

protocol RocketListDataSourceDelegate: AnyObject {
    func didSelect(item: RocketListData)
}

class RocketListDataSource: NSObject, RocketListDataSourceType {
    weak var delegate: RocketListDataSourceDelegate?
    enum Section: CaseIterable {
        case main
    }
    private typealias DataSource = UITableViewDiffableDataSource<Section, RocketListData>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RocketListData>

    private lazy var dataSource = makeDataSource()
    private let tableView: UITableView
    private var items: [RocketListData] = []
    private let imageProvider: ImageProvider

    init(tableView: UITableView, imageProvider: ImageProvider) {
        self.tableView = tableView
        self.imageProvider = imageProvider
        super.init()
        self.tableView.delegate = self
        update(data: items)
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: RocketListTableViewCell.identifier,
                                                         for: indexPath) as? RocketListTableViewCell
                cell?.config(item: item,
                             imageProvider: self.imageProvider)
                return cell
            })
        dataSource.defaultRowAnimation = .fade

        return dataSource
    }

    func update(data: [RocketListData]) {
        var snapshot = dataSource.snapshot()
        if !snapshot.sectionIdentifiers.contains(.main) {
            snapshot.appendSections([.main])

        }
        items = data
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: !data.isEmpty)
    }
}

// MARK: - UITableViewDelegate

extension RocketListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(item: items[indexPath.item])
    }
}
