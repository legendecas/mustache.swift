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

class ScannerTests: XCTestCase {

  func testScan() {
    let scanner = Scanner(of: "a test string of {{Scanner}}")
    expect(scanner.eos) == false
    expect(scanner.scan(for: try NSRegularExpression(pattern: "\\{\\{"))).to(beNil())
    expect(scanner.scan(for: try NSRegularExpression(pattern: "\\w"))) == "a"
    expect(scanner.scan(for: try NSRegularExpression(pattern: "(?:\\w|\\ )+"))) == " test string of "
    expect(try scanner.scan(for: "\\{\\{")) == "{{"
    expect(try scanner.scan(for: "\\w+")) == "Scanner"
    expect(try scanner.scan(for: "\\}\\}")) == "}}"
    expect(scanner.eos) == true
    expect { try scanner.scan(for: "{{I am a malicious regex}}") }.to(throwError())
    expect(try scanner.scan(for: ".*")).to(beNil())
  }

  func testScanUntil() {
    let scanner = Scanner(of: "a test string of {{Scanner}}")
    expect(scanner.eos) == false
    expect(try scanner.scan(until: "\\{\\{")) == "a test string of "
    expect(try scanner.scan(until: "\\ ")) == "{{Scanner}}"
    expect(scanner.eos) == true
    expect(try scanner.scan(until: ".*")).to(beNil())
  }

}
