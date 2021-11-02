import XCTest
@testable import SpaceX
class RocketListViewModelTests: XCTestCase {

    enum Constants {
        static let timeout: TimeInterval = 1.0
        static let fetchDataDescription = "dataFetchedSetsProperly"
    }
    var sut: RocketListViewModel!
    var coordinator: AppCoordinatorMock!
    var imageProvider: ImageProviderMock!
    var dataProvider: RocketListDataProvider!
    
    override func setUpWithError() throws {
        try! super.setUpWithError()
        dataProvider = RocketListDataProviderMock(api: SpaceXAPIMock())
        coordinator = AppCoordinatorMock()
        imageProvider = ImageProviderMock()

        sut = RocketListViewModel(dataProvider: dataProvider,
                                  imageProvider: imageProvider,
                                  coordinator: coordinator)
    }

    override func tearDownWithError() throws {
        try! super.tearDownWithError()
        dataProvider = nil
        coordinator = nil
        imageProvider = nil
        sut = nil
    }

    func test_fetchData() {
        let expect = expectation(description: Constants.fetchDataDescription)

        sut.fetchList().map({ success in
            XCTAssertTrue(success)
            expect.fulfill()
        }).cauterize()

        waitForExpectations(timeout: Constants.timeout) { error in
            if let error = error {
                XCTFail("Failed to fetch SpaceXRocketMock Data \(String(describing: error))")
            }
        }
    }
}
