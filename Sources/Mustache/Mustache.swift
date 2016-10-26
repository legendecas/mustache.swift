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

public struct Mustache {

  public static func render(
    _ template: String,
    with context: [String: CustomStringConvertible]
  ) -> String {
    let writer = Writer()
    let parser = Parser()

    let tokens = try! parser.parse(template: template)

    return writer.render(tokens, with: Context(context))
  }

}
