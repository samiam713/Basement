import XCTest
@testable import Basement

final class BasementTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Basement().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
