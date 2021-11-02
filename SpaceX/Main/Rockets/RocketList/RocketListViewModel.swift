import Foundation
import PromiseKit
import UIKit

final class RocketListViewModel {

    // MARK: - Properties
    private let coordinator: AppCoordinatorType
    private var dataSource: RocketListDataSourceType?
    private var imageProvider: ImageProvider
    private let dataProvider: RocketListDataProvider

    init(dataProvider: RocketListDataProvider,
         imageProvider: ImageProvider,
         coordinator: AppCoordinatorType) {
        self.dataProvider = dataProvider
        self.coordinator = coordinator
        self.imageProvider = imageProvider
    }

    func set(tableView: UITableView,
             delegate: RocketListDataSourceDelegate) {
        self.dataSource = RocketListDataSource(tableView: tableView,
                                               imageProvider: imageProvider)
        self.dataSource?.delegate = delegate
    }

    // MARK: - Coordinator Methods
    func viewDetail(data: RocketListData) {
        coordinator.moveToDetail(data: data)
    }


    // MARK: - Data Management
    private func createDataSourceData(data: [RocketListResponseBody]) -> [RocketListData] {
        var rocketListData = [RocketListData]()
        for item in data {
            let rocketList = RocketListData(id: item.id,
                                            images: item.imagesURL,
                                            title: item.name)
            rocketListData.append(rocketList)
        }
        return rocketListData
    }

    // MARK: - Network Calls
    func fetchList() -> Guarantee<Bool> {
        return dataProvider.fetchRocketList().map { data in
            self.dataSource?.update(data: self.createDataSourceData(data: data))
            return true
        }.recover { error in
            // TODO: Error handling
            return .value(false)
        }
    }
}
