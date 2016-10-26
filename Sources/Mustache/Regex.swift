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

struct Regex {
  let pattern: String
  let options: NSRegularExpression.Options

  var regex: NSRegularExpression? {
    return try? NSRegularExpression(pattern: pattern, options: options)
  }

  init(pattern: String, options: NSRegularExpression.Options = []) {
    self.pattern = pattern
    self.options = options
  }

  func match(string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
    return (regex?.numberOfMatches(
      in: string,
      options: options,
      range: NSRange(location: 0, length: string.characters.count)
    ) ?? 0) == 1
  }
}

protocol RegularExpressionMatchable {
  func match(regex: Regex) -> Bool
}

func ~=<T: RegularExpressionMatchable>(pattern: Regex, matchable: T) -> Bool {
  return matchable.match(regex: pattern)
}

extension String: RegularExpressionMatchable {
  func match(regex: Regex) -> Bool {
    return regex.match(string: self)
  }
}
