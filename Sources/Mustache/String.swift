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

  func trimed() -> String {
    return trimmingCharacters(in: CharacterSet(charactersIn: " "))
  }

}
