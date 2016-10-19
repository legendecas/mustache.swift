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

class WriterTests: XCTestCase {

  let writer = Writer()

  func testRenderText() {
    let text = "hello world"
    let tokens: [Token] = [.text(text, text.startIndex..<text.endIndex)]
    expect(text) == writer.render(tokens, with: Context([:]))
  }

  func testRenderVariable() {
    let template = "hello {{world}}"
    let tokens: [Token] = [
      .text("hello ", template.range(of: "hello ")!),
      .variable("world", template.range(of: "{{world}}")!),
    ]
    let context = Context(["world": "<b>world!</b>"])
    expect("hello &lt;b&gt;world!&lt;/b&gt;") == writer.render(tokens, with: context)
  }

  func testRenderUnescapedVariable() {
    let template = "hello {{{world}}}"
    let tokens: [Token] = [
      .text("hello ", template.range(of: "hello ")!),
      .unescapedVariable("world", template.range(of: "{{world}}")!),
    ]
    let context = Context(["world": "<b>world!</b>"])
    expect("hello <b>world!</b>") == writer.render(tokens, with: context)
  }

  func testRenderSectionWithTruthyValue() {
    let template1 = "{{#shown?}}Shown!{{/shown}}"
    let tokens1: [Token] = [
      .section("shown?", template1.startIndex..<template1.endIndex, [
        .text("Shown!", template1.range(of: "Shown!")!),
      ]),
    ]
    let template2 = "{{#shouldNotShown}}Bad, I'm here{{/shouldNotShown}}"
    let tokens2: [Token] = [
      .section("shouldNotShown", template2.startIndex..<template2.endIndex, [
        .text("Bad, I'm here", template2.range(of: "Bad, I'm here")!),
      ]),
    ]
    let context = Context(["shown?": true, "shouldNotShown": false])
    expect("Shown!") == writer.render(tokens1, with: context)
    expect("") == writer.render(tokens2, with: context)
  }

  func testRenderSectionWithList() {
    let template = "{{#repo}}<b>{{name}}</b>\n{{/repo}}"
    let tokens: [Token] = [
      .section("repo", template.startIndex..<template.endIndex, [
        .text("<b>", template.range(of: "<b>")!),
        .variable("name", template.range(of: "{{name}}")!),
        .text("</b>\n", template.range(of: "</b>\n")!),
      ])
    ]
    let context = Context(["repo": [
      ["name": "resque"],
      ["name": "hub"],
      ["name": "rip"],
    ]])
    expect("<b>resque</b>\n<b>hub</b>\n<b>rip</b>\n") == writer.render(tokens, with: context)
  }

  func testRenderSectionWithDict() {
    let template = "{{#repo}}<b>{{name}}</b>{{/repo}}"
    let tokens: [Token] = [
      .section("repo", template.startIndex..<template.endIndex, [
        .text("<b>", template.range(of: "<b>")!),
        .variable("name", template.range(of: "{{name}}")!),
        .text("</b>", template.range(of: "</b>")!),
      ])
    ]
    let context = Context(["repo": ["name": "resque"]])
    expect("<b>resque</b>") == writer.render(tokens, with: context)
  }

  func testRenderInvertedSection() {
    let template = "{{^repo}}No repos :({{/repo}}"
    let tokens: [Token] = [
      .invertedSection("repo", template.startIndex..<template.endIndex, [
        .text("No repos :(", template.range(of: "No repos :(")!),
      ])
    ]
    let context = Context(["repo": [] as [String]])
    expect("No repos :(") == writer.render(tokens, with: context)
  }

}
