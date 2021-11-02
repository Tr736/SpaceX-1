import XCTest
@testable import SpaceX

class RocketListDataProviderTest: XCTestCase {
    private enum Constants {
        static let timeout: TimeInterval = 1.0
        static let fetchDataDescription = "dataFetchedSetsProperly"
    }
    var sut: RocketListDataProvider!
    var api: SpaceXAPIMock!

    override func setUpWithError() throws {
        api = SpaceXAPIMock()
        sut = ConcreteRocketListDataProvider(api: api)
    }

    override func tearDownWithError() throws {
        api = nil
        sut = nil
    }

    func test_fetchRocketList_shouldDecode() {
        let expect = expectation(description: Constants.fetchDataDescription)

        guard let json = try? loadContents(of: "SpaceXRocketMockData", with: "json") else {
            XCTFail("Failed to load contents of SpaceXRocketMockData file")
            return
        }

        api.executeReturnData = json

        sut.fetchRocketList().done { data in

            XCTAssertNotNil(data.first?.id)
            XCTAssertNotNil(data.first?.imagesURL)
            XCTAssertNotNil(data.first?.height)
            XCTAssertNotNil(data.first?.name)
            XCTAssertNotNil(data.first?.type)
            XCTAssertNotNil(data.first?.boosters)
            XCTAssertNotNil(data.first?.company)
            XCTAssertNotNil(data.first?.costPerLaunch)
            XCTAssertNotNil(data.first?.diameter)
            XCTAssertNotNil(data.first?.landingLegs)


            // TODO: Write more tests to ensure all items are decoded and that nil values are correctly delt with
            expect.fulfill()
        }.catch { error in
            XCTAssertThrowsError(error)
        }

        waitForExpectations(timeout: Constants.timeout) { error in
            if let error = error {
                XCTFail("Failed to fetch SpaceXRocketMock Data \(String(describing: error))")
            }
        }
    }

}
