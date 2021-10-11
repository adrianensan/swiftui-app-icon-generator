// swift-tools-version:5.5
import PackageDescription

let useLocal = false
let dependencies: [Package.Dependency]
if useLocal {
  dependencies = [
    .package(name: "SwiftConvenience",
             path: "~/Repos/swift-packages/swift-convenience"),
    .package(name: "SwiftUIConvenience",
             path: "~/Repos/swift-packages/swiftui-convenience"),
    .package(name: "HelloColor",
             path: "~/Repos/swift-packages/hello-color")
  ]
} else {
  dependencies = [
    .package(name: "SwiftConvenience",
             url: "https://github.com/hello-apps/swift-convenience",
             branch: "main"),
    .package(name: "SwiftUIConvenience",
             url: "https://github.com/hello-apps/swiftui-convenience",
             branch: "main"),
    .package(name: "HelloColor",
             url: "https://github.com/hello-apps/hello-color",
             branch: "main")
  ]
}

let package = Package(
  name: "AppIconGenerator",
  platforms: [ .macOS(.v12)],
  products: [
    .library(
      name: "AppIconGenerator",
      targets: ["AppIconGenerator"]),
  ],
  dependencies: dependencies,
  targets: [
    .target(
      name: "AppIconGenerator",
      dependencies: [
        .byNameItem(name: "SwiftConvenience", condition: nil),
        .byNameItem(name: "SwiftUIConvenience", condition: nil),
        .byNameItem(name: "HelloColor", condition: nil),
      ]),
    .testTarget(
      name: "AppIconGeneratorTests",
      dependencies: ["AppIconGenerator"]),
  ]
)
