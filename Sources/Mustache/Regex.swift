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
