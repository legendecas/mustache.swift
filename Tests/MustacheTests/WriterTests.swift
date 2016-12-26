import Foundation
import Nimble
import XCTest
@testable import Mustache

class WriterTests: XCTestCase {

  let writer = Writer()

  func testRenderText() {
    let text = "hello world"
    let tokens: [Token] = [.text(text, at: text.startIndex..<text.endIndex)]
    expect(text) == writer.render(tokens, with: Context([:]))
  }

  func testRenderVariable() {
    let template = "hello {{world}}"
    let tokens: [Token] = [
      .text("hello ", at: template.range(of: "hello ")!),
      .variable("world", at: template.range(of: "{{world}}")!),
    ]
    let context = Context(["world": "<b>world!</b>"])
    expect("hello &lt;b&gt;world!&lt;/b&gt;") == writer.render(tokens, with: context)
  }

  func testRenderUnescapedVariable() {
    let template = "hello {{{world}}}"
    let tokens: [Token] = [
      .text("hello ", at: template.range(of: "hello ")!),
      .unescapedVariable("world", at: template.range(of: "{{world}}")!),
    ]
    let context = Context(["world": "<b>world!</b>"])
    expect("hello <b>world!</b>") == writer.render(tokens, with: context)
  }

  func testRenderSectionWithTruthyValue() {
    let template1 = "{{#shown?}}Shown!{{/shown}}"
    let tokens1: [Token] = [
      .section("shown?", at: template1.startIndex..<template1.endIndex, of: [
        .text("Shown!", at: template1.range(of: "Shown!")!),
      ]),
    ]
    let template2 = "{{#shouldNotShown}}Bad, I'm here{{/shouldNotShown}}"
    let tokens2: [Token] = [
      .section("shouldNotShown", at: template2.startIndex..<template2.endIndex, of: [
        .text("Bad, I'm here", at: template2.range(of: "Bad, I'm here")!),
      ]),
    ]
    let context = Context(["shown?": true, "shouldNotShown": false])
    expect("Shown!") == writer.render(tokens1, with: context)
    expect("") == writer.render(tokens2, with: context)
  }

  func testRenderSectionWithList() {
    let template = "{{#repo}}<b>{{name}}</b>\n{{/repo}}"
    let tokens: [Token] = [
      .section("repo", at: template.startIndex..<template.endIndex, of: [
        .text("<b>", at: template.range(of: "<b>")!),
        .variable("name", at: template.range(of: "{{name}}")!),
        .text("</b>\n", at: template.range(of: "</b>\n")!),
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
      .section("repo", at: template.startIndex..<template.endIndex, of: [
        .text("<b>", at: template.range(of: "<b>")!),
        .variable("name", at: template.range(of: "{{name}}")!),
        .text("</b>", at: template.range(of: "</b>")!),
      ])
    ]
    let context = Context(["repo": ["name": "resque"]])
    expect("<b>resque</b>") == writer.render(tokens, with: context)
  }

  func testRenderInvertedSection() {
    let template = "{{^repo}}No repos :({{/repo}}"
    let tokens: [Token] = [
      .invertedSection("repo", at: template.startIndex..<template.endIndex, of: [
        .text("No repos :(", at: template.range(of: "No repos :(")!),
      ])
    ]
    let context = Context(["repo": [] as [String]])
    expect("No repos :(") == writer.render(tokens, with: context)
  }

}
