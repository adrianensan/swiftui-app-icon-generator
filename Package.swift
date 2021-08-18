// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "AppIconGenerator",
  platforms: [
    .iOS(.v14),
      .macOS(.v11)
  ],
  products: [
    .library(
      name: "AppIconGenerator",
      targets: ["AppIconGenerator"]),
  ],
  dependencies: [
    .package(name: "SwiftConvenience",
             url: "https://github.com/adrianensan/swift-convenience",
             branch: "main"),
    .package(name: "SwiftUIConvenience",
             url: "https://github.com/adrianensan/swiftui-convenience",
             branch: "main"),
    .package(name: "SelfUI",
             url: "https://github.com/adrianensan/self-shared-ui",
             branch: "main")
  ],
  targets: [
    .target(
      name: "AppIconGenerator",
      dependencies: [
        .byNameItem(name: "SwiftConvenience", condition: nil),
        .byNameItem(name: "SwiftUIConvenience", condition: nil),
        .byNameItem(name: "SelfUI", condition: nil)
      ]),
    .testTarget(
      name: "AppIconGeneratorTests",
      dependencies: ["AppIconGenerator"]),
  ]
)
