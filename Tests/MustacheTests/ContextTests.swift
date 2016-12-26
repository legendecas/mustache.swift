import Foundation
import XCTest
import Nimble
@testable import Mustache

class ContextTests: XCTestCase {

  func testLocalLookup() {
    let context = Context([
      "key-a": 1,
      "key-b": [1, 2, 3],
      "key-c": ["child": "value"]
    ])
    expect(1) == context.lookup("key-a") as? Int

    expect([1, 2, 3]) == context.lookup("key-b") as? [Int]
    expect(1) == context.lookup("key-b.0") as? Int

    expect(["child": "value"]) == context.lookup("key-c") as? [String: String]
    expect("value") == context.lookup("key-c.child") as? String
  }

  func testParentLookup() {
    let parent = Context(["key": "value", "shadowed": "parent-value"])
    let context = parent.push(["shadowed": "child-value"])
    expect("child-value") == context.lookup("shadowed") as? String
    expect("value") == context.lookup("key") as? String
  }

}
