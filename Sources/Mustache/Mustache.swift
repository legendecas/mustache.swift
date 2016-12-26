import Foundation

public struct Mustache {

  public static func render(
    _ template: String,
    with context: [String: CustomStringConvertible]
  ) throws -> String {
    let writer = Writer()
    let parser = Parser()

    let tokens = try parser.parse(template: template)

    return writer.render(tokens, with: Context(context))
  }

  public static func render(
    path: String,
    with context: [String: CustomStringConvertible],
    encoding: String.Encoding = .utf8
  ) throws -> String {
    let writer = Writer()
    let parser = Parser()

    guard let file = FileHandle(forReadingAtPath: path) else {
      throw MustacheError.fileNotFound
    }

    let data = file.readDataToEndOfFile()
    guard let template = String(data: data, encoding: encoding) else {
      throw MustacheError.encodingNotMatch
    }

    let tokens = try parser.parse(template: template)
    return writer.render(tokens, with: Context(context))
  }

}
