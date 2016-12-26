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
