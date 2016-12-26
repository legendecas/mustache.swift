import Foundation

enum MustacheError: Error {
  case unopenedSection(String, at: Range<String.Index>)
  case unclosedSection(String, at: Range<String.Index>)
  case unclosedTag(String, at: Range<String.Index>)

  case fileNotFound
  case encodingNotMatch
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
