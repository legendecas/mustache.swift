import Foundation
import Nimble
import XCTest
@testable import Mustache

class ParserTests: XCTestCase {

  func testParseSimpleTemplate() {
    let parser = Parser()
    let template = "hello {{world}}"
    let tokens = try! parser.parse(template: template)
    expect(tokens) == [
      .text("hello ", at: template.range(of: "hello ")!),
      .variable("world", at: template.range(of: "{{world}}")!),
    ]
  }

  func testUnclosedTagError() {
    let parser = Parser()
    let template = "hello {{world}} - {{ error opened tag"
    expect { try parser.parse(template: template) }
      .to(throwError { error in
        expect(error)
          .to(matchError(MustacheError
            .unclosedTag(" error opened tag", at: template.range(of: "{{ error opened tag")!)))
      })
  }
}
