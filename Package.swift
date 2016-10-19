import PackageDescription

let package = Package(
  name: "MustacheSwift",
  targets: [
    Target(name: "Mustache"),
    Target(name: "CommandLine", dependencies: ["Mustache"])
  ],
  dependencies: [
    .Package(url: "https://github.com/IBM-Swift/swift-html-entities", majorVersion: 1),
    .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 5)
  ]
)

let dylib = Product(name: "Mustache", type: .Library(.Dynamic), modules: "Mustache")
products.append(dylib)
