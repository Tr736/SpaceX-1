import UIKit

public protocol AppCoordinatorType {
    func start()
    func moveToDetail(data: RocketListData)
}

struct AppCoordinator: Coordinator, AppCoordinatorType {
    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController
    private let imageProvider: ImageProvider

    init(navigationController: UINavigationController,
         imageProvider: ImageProvider) {
        self.imageProvider = imageProvider
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = RocketListViewModel(dataProvider: ConcreteRocketListDataProvider(api: ConcreteSpaceXAPI()),
                                            imageProvider: imageProvider,
                                            coordinator: self)
        let vc = RocketListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc,
                                                animated: false)
    }

    func moveToDetail(data: RocketListData) {
        let vc = RocketListDetailViewController(viewModel: RocketListDetailViewModel())
        navigationController.pushViewController(vc,
                                                animated: true)
    }
}
