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
