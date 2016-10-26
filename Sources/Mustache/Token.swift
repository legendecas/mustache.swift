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

/// Tag type
///
/// - text:              normal text tag type (value, position)
/// - variable:          variable tag type (keypath, position)
/// - unescapedVariable: unescaped HTML variable tag  type (keypath, position)
/// - section:           section block tag type (keypath, position, sub-tags)
/// - invertedSection:   inverted section tag type (keypath, position, sub-tags)
/// - partial:           partial tag type (partial_name, position)
enum Token {
  case text(String, at: Range<String.Index>)
  case variable(String, at: Range<String.Index>)
  case unescapedVariable(String, at: Range<String.Index>)
  case section(String, at: Range<String.Index>, of: [Token])
  case invertedSection(String, at: Range<String.Index>, of: [Token])
  case partial(String, at: Range<String.Index>)
}

extension Token: CustomStringConvertible {
  var description: String {
    switch self {
    case .text(let content, _):
      return "<Text tag: \(content)>"
    case .variable(let keypath, _):
      return "<Variable tag: \(keypath)>"
    case .unescapedVariable(let keypath, _):
      return "<Unescaped variable tag: \(keypath)>"
    case .section(let section, _, let subTokens):
      return "<Section tag: \(section), \(subTokens.map { $0.description })>"
    case .invertedSection(let section, _, let subTokens):
      return "<Inverted section tag: \(section), \(subTokens.map { $0.description })>"
    case .partial(let partial, _):
      return "<Partial tag: \(partial)"
    }
  }
}
