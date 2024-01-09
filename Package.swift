// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AttributedText",
  platforms: [.iOS(.v16), .macOS(.v13), .watchOS(.v9), .tvOS(.v16), .macCatalyst(.v16)],
  products: [
    .library(
      name: "AttributedText",
      targets: ["AttributedText"]
    ),
  ],
  targets: [
    .target(
      name: "AttributedText"
    ),
  ]
)
