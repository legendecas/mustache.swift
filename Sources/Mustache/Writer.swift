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
