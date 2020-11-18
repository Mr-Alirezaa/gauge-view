import XCTest
@testable import Gauge

final class GaugeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Gauge().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
