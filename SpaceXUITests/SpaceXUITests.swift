import XCTest
// TODO: Do no use Live network for UI Tests. Consider WireMock!

class SpaceXUITests: XCTestCase {

    private enum AccessibilityIdentifier {
        static let tableViewId = "RocketListTableView"
        static let viewId = "RocketListView"
        static let cell = "RocketList_cell"
        static let imageView = "image_view"
    }

    func test_tableViewIsVisible() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let tableview = app.tables[AccessibilityIdentifier.tableViewId]
        XCTAssertTrue(tableview.waitForExistence(timeout: 0.2))
    }

    func test_rocketCellView_IsVisible() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let tableview = app.tables[AccessibilityIdentifier.tableViewId]
        let cell = tableview.cells[AccessibilityIdentifier.cell]
        XCTAssertTrue(cell.waitForExistence(timeout: 0.2))
    }
}
