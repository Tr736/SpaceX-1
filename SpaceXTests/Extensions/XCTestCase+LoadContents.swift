import XCTest
extension XCTestCase {
    func loadContents(of fileNamed: String, with fileType: String) throws -> Data {
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: fileNamed, withExtension: fileType) else {
            preconditionFailure("file \(fileNamed) not found in \(bundle.bundlePath)")
        }
        return try Data(contentsOf: url)
    }
}
