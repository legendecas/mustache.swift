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