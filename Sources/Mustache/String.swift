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

extension String {

  /// Return corresponding `Range<String.Index>` object of given `NSRange` object
  ///
  /// - parameter range: `NSRange` object
  ///
  /// - returns: corresponding `Range<String.Index>` object, nil if out of string's range
  func range(of range: NSRange) -> Range<Index>? {
    let from16 = UTF16Index.init(startIndex, within: utf16).advanced(by: range.location)
    guard let from = String.Index.init(from16, within: self) else { return nil }

    let to16 = from16.advanced(by: range.length)
    guard let to = String.Index.init(to16, within: self) else { return nil }

    return from ..< to
  }

  /// Returns a string object containing the characters of the String that lie within a given range.
  func substring(of aNSRange: NSRange) -> String? {
    guard let range = range(of: aNSRange) else { return nil }
    return self[range]
  }

}
