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

enum MustacheError: Error {
  case unopenedSection(String, at: Range<String.Index>)
  case unclosedSection(String, at: Range<String.Index>)
  case unclosedTag(String, at: Range<String.Index>)
}

extension MustacheError: Equatable {
  static func == (lhs: MustacheError, rhs: MustacheError) -> Bool {
    switch (lhs, rhs) {
    case (.unopenedSection(let lhsSection, let lhsRange), .unopenedSection(let rhsSection, let rhsRange)):
      return lhsSection == rhsSection && lhsRange == rhsRange
    case (.unclosedSection(let lhsSection, let lhsRange), .unclosedSection(let rhsSection, let rhsRange)):
      return lhsSection == rhsSection && lhsRange == rhsRange
    case (.unclosedTag(let lhsSection, let lhsRange), .unclosedTag(let rhsSection, let rhsRange)):
      return lhsSection == rhsSection && lhsRange == rhsRange
    default:
      return false
    }
  }
}
