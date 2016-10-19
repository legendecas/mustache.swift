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
  case text(String, Range<String.Index>)
  case variable(String, Range<String.Index>)
  case unescapedVariable(String, Range<String.Index>)
  case section(String, Range<String.Index>, [Token])
  case invertedSection(String, Range<String.Index>, [Token])
  case partial(String, Range<String.Index>)
}
