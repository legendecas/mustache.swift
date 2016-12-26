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

extension Token: Equatable {
  static func == (lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.text(let lhsText, let lhsRange), .text(let rhsText, let rhsRange)):
      return lhsText == rhsText && lhsRange == rhsRange
    case (.variable(let lhsVariable, let lhsRange), .variable(let rhsVariable, let rhsRange)):
      return lhsVariable == rhsVariable && lhsRange == rhsRange
    default:
      return false
    }
  }
}
