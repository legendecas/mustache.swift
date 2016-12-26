import Foundation

class Parser {

  let openingTag = try! NSRegularExpression(pattern: "\\{\\{")
  let closingTag = try! NSRegularExpression(pattern: "\\}\\}")
  let tags = try! NSRegularExpression(pattern: "\\{|&|#|\\^|>|!|\\/")

  enum Tag: String {
    case variable = "variable tag"
    case unescapedVariable = "\\{|&"
    case section = "#"
    case invertedSection = "\\^"
    case partial = ">"
    case comment = "!"
    case close = "\\/"

    static func from(string: String) -> Tag {
      switch string {
      case Regex(pattern: Tag.unescapedVariable.rawValue):
        return .unescapedVariable
      case Regex(pattern: Tag.section.rawValue):
        return .section
      case Regex(pattern: Tag.invertedSection.rawValue):
        return .invertedSection
      case Regex(pattern: Tag.partial.rawValue):
        return .partial
      case Regex(pattern: Tag.comment.rawValue):
        return .comment
      case Regex(pattern: Tag.close.rawValue):
        return .close
      default:
        return .variable
      }
    }
  }

  func parse(scanner: Scanner, in section: String? = nil) throws -> [Token] {
    var tokens: [Token] = []
    var sectionClosed = false
    while !scanner.eos && !sectionClosed {
      let previousPosition = scanner.position
      if let text = scanner.scan(until: openingTag) {
        let tagStartPosition = scanner.position
        tokens.append(.text(text, at: previousPosition..<scanner.position))
        if let _ = scanner.scan(for: openingTag) {
          let type = Tag.from(string: scanner.scan(for: tags) ?? "")

          if let content = scanner.scan(until: closingTag)?.trimed() {
            if let _ = scanner.scan(for: closingTag) {
              switch type {
              case .variable:
                tokens.append(.variable(content, at: tagStartPosition..<scanner.position))
              case .unescapedVariable:
                tokens.append(.unescapedVariable(content, at: tagStartPosition..<scanner.position))
              case .partial:
                tokens.append(.partial(content, at: tagStartPosition..<scanner.position))
              case .close:
                if section == nil || section != content {
                  throw MustacheError.unopenedSection(content, at: tagStartPosition..<scanner.position)
                } else {
                  sectionClosed = true
                }
              case .section:
                let subTokens = try parse(scanner: scanner, in: content)
                tokens.append(.section(content, at: tagStartPosition..<scanner.position, of: subTokens))
              case .invertedSection:
                let subTokens = try parse(scanner: scanner, in: content)
                tokens.append(.invertedSection(content, at: tagStartPosition..<scanner.position, of: subTokens))
              case .comment:
                break
              }
            } else {
              throw MustacheError.unclosedTag(content, at: tagStartPosition..<scanner.position)
            }
          }
        }
      }
    }
    return tokens
  }

  func parse(template: String) throws -> [Token] {
    let scanner = Scanner(of: template)
    return try parse(scanner: scanner)
  }
}
