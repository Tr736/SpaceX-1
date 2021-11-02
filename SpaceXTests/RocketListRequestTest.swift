import XCTest
@testable import SpaceX

class RocketListRequestTest: XCTestCase {
    private enum Constants {
        static let path = "/v4/rockets"
    }
    var sut: RocketListRequest!
    override func setUpWithError() throws {
        sut = RocketListRequest()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_GetListRequest() {
        XCTAssertEqual(Constants.path, sut.path)
        XCTAssertEqual(.get, sut.method)
    }
}
