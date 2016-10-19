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

/// Represets a rendering context by wrapping a dict and maintaining
/// a reference to the parent context.
class Context {

  typealias ValueType = CustomStringConvertible
  typealias Dict = [String: ValueType]

  private let dict: Dict
  private let parent: Context?

  init(_ dictionary: Dict, parent: Context? = nil) {
    dict = dictionary
    self.parent = parent
  }

  /// Creates a new context using the given dict with this context as the parent.
  ///
  /// - parameter dict: child context's dict.
  ///
  /// - returns: child context.
  func push(_ dict: Dict) -> Context {
    return Context(dict, parent: self)
  }

  /// Returns the value of the given keypath in the context.
  ///
  /// - parameter keypath: using the dot notion path descend through the nested dicts.
  ///
  /// - returns: the value of the given name in this context, traversing up the context hierarchy
  ///            if the value is absent in this context's dict.
  func lookup(_ keypath: String) -> ValueType? {
    let keys = keypath.characters.split(separator: ".").map(String.init)
    if keys.count > 1 {
      let value = dict[keys[0]] ?? parent?.lookup(keys[0])
      return keys[1..<keys.endIndex].reduce(value) { result, key -> ValueType? in
        if let dict = result as? Dict {
          return dict[key]
        } else if let array = result as? [ValueType], let index = Int(key) {
          if index < array.count && index >= 0 {
            return array[index]
          }
        }
        return nil
      }
    } else {
      return dict[keypath] ?? parent?.lookup(keypath)
    }
  }
}
