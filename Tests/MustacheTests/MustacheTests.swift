import XCTest
@testable import Mustache

class MustacheTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertEqual(Mustache().text, "Hello, World!")
  }

  static var allTests: [(String, (MustacheTests) -> () throws -> Void)] {
    return [
      ("testExample", testExample),
    ]
  }
}
