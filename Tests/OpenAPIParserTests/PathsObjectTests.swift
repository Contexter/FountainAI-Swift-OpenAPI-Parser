import XCTest

final class PathsObjectTests: XCTestCase {
    func testGetPath_ValidPath() {
        let paths = PathsObject(paths: ["/test": PathItemObject()])
        XCTAssertNotNil(paths.getPath("/test"))
    }

    func testGetPath_InvalidPath() {
        let paths = PathsObject(paths: ["/test": PathItemObject()])
        XCTAssertNil(paths.getPath("/invalid"))
    }

    func testSubscript_ValidPath() {
        let paths = PathsObject(paths: ["/test": PathItemObject()])
        XCTAssertNotNil(paths["/test"])
    }

    func testSubscript_InvalidPath() {
        let paths = PathsObject(paths: ["/test": PathItemObject()])
        XCTAssertNil(paths["/invalid"])
    }
}

