import Foundation

/// A simple string scanner that is used by template parser to find tokens in template string.
class Scanner {

  let string: String
  var position: String.Index

  init(of str: String) {
    string = str
    position = str.startIndex
  }

  /// Range to search
  var searchRange: NSRange {
    let location = string.distance(from: string.startIndex, to: position)
    let length = string.distance(from: position, to: string.endIndex)
    return NSRange(location: location, length: length)
  }

  /// End of string
  var eos: Bool {
    return position == string.endIndex
  }

  /// Tries to match the given regular expression at current position.
  ///
  /// - parameter regex: regular expression to match.
  ///
  /// - returns: the matched text if it can match, otherwise nil.
  func scan(for regex: NSRegularExpression) -> String? {
    guard !eos else { return nil }
    guard let match = regex.firstMatch(in: string, range: searchRange) else { return nil }
    guard let range = string.range(of: match.range) else { return nil }
    guard range.lowerBound == position else { return nil }

    position = range.upperBound

    return string[range]
  }

  /// Tries to match the given regular expression string at current position.
  ///
  /// - parameter re: regular expression string to match.
  ///
  /// - throws: NSRegularExpression initialization error.
  ///
  /// - returns: the matched test if it can match, otherwise nil.
  func scan(for re: String) throws -> String? {
    let regex = try NSRegularExpression(pattern: re)
    return scan(for: regex)
  }

  /// Skips all text until given regular expression can be matched.
  ///
  /// - parameter regex: regular expression to match.
  ///
  /// - returns: the skipped string, which is the entire tail if no match can be made.
  func scan(until regex: NSRegularExpression) -> String? {
    guard !eos else { return nil }

    if let match = regex.firstMatch(in: string, range: searchRange) {
      guard let range = string.range(of: match.range) else { return nil }
      defer { position = range.lowerBound }
      return string[position..<range.lowerBound]
    } else {
      defer { position = string.endIndex }
      return string[position..<string.endIndex]
    }
  }

  /// Skips all text until giben regular expression string can be matched.
  ///
  /// - parameter re: regular expression string to match.
  ///
  /// - throws: NSRegularExpression initialization error.
  ///
  /// - returns: the skipped string, which is the entire tail if no match can be made.
  func scan(until re: String) throws -> String? {
    let regex = try NSRegularExpression(pattern: re)
    return scan(until: regex)
  }

  /// <#Description#>
  func stepBack() {
    position = string.index(before: position)
  }

}
