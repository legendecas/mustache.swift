//  Copyright 2016 Lucas Woo <legendecas@gmail.com>
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
