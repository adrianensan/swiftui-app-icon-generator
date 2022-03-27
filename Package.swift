// swift-tools-version:5.5
import PackageDescription
import Foundation

var helloPackagesPath = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("/Developer/Hello/packages/", isDirectory: true).absoluteString
if helloPackagesPath.hasPrefix("file://") {
  helloPackagesPath.removeFirst(7)
}

let helloColorPackage: Package.Dependency
if FileManager.default.fileExists(atPath: "\(helloPackagesPath)hello-color") {
  helloColorPackage = .package(name: "HelloColor", path: "\(helloPackagesPath)hello-color")
} else {
  helloColorPackage = .package(url: "https://github.com/hello-apps/hello-color",
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
        .product(name: "HelloColor", package: "hello-color")
      ]),
    .testTarget(
      name: "AppIconGeneratorTests",
      dependencies: ["AppIconGenerator"]),
  ]
)
