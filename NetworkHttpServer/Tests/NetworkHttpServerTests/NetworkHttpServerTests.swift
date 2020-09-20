import XCTest
@testable import NetworkHttpServer

final class NetworkHttpServerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NetworkHttpServer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
