// swift-tools-version:5.5
import PackageDescription
import Foundation

let helloColorPackage: Package.Dependency
if FileManager.default.fileExists(atPath: "Users/adrian/Repos/swift-packages/hello-color") {
  helloColorPackage = .package(name: "HelloColor",
                                     path: "~/Repos/swift-packages/hello-color")
} else {
  helloColorPackage = .package(name: "HelloColor",
                                     url: "https://github.com/hello-apps/hello-color",
                                     branch: "main")
}

let dependencies: [Package.Dependency] = [
  helloColorPackage
]

let package = Package(
  name: "AppIconGenerator",
  platforms: [.macOS(.v12)],
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
        .byNameItem(name: "HelloColor", condition: nil)
      ]),
    .testTarget(
      name: "AppIconGeneratorTests",
      dependencies: ["AppIconGenerator"]),
  ]
)
