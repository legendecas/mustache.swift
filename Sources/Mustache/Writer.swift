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
import HTMLEntities

class Writer {

  /// Render given token array into string output.
  ///
  /// - parameter tokens:  array of Token enum type to be renderred.
  /// - parameter context: renderring context.
  ///
  /// - returns: renderred result.
  func render(_ tokens: [Token], with context: Context) -> String {
    return tokens.map { token -> String in
      switch token {
      case let .text(value, _):
        return value
      case let .variable(keypath, _):
        let result = context.lookup(keypath) ?? ""
        return result.description.htmlEscape()
      case let .unescapedVariable(keypath, _):
        let result = context.lookup(keypath) ?? ""
        return result.description
      case let .section(keypath, _, subTokens):
        if let value = context.lookup(keypath) {
          if let bool = Bool(value.description) {
            if bool {
              return render(subTokens, with: context)
            }
          } else if let array = value as? [Context.Dict] {
            return array.map { render(subTokens, with: Context($0, parent: context)) }.joined()
          } else if let dict = value as? Context.Dict {
            return render(subTokens, with: Context(dict, parent: context))
          }
        }
        return ""
      case let .invertedSection(keypath, _, subTokens):
        if let value = context.lookup(keypath) {
          if let bool = Bool(value.description) {
            if !bool {
              return render(subTokens, with: context)
            }
          } else if let array = value as? [Context.Dict] {
            if array.count == 0 {
              return render(subTokens, with: context)
            }
          }
        } else {
          return render(subTokens, with: context)
        }
        return ""
      default:
        return ""
      }
    }.joined()
  }

}
