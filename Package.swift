// swift-tools-version:5.7
import PackageDescription
import Foundation

var helloPackagesPath: String = #file
helloPackagesPath = String(helloPackagesPath[...helloPackagesPath.lastIndex(of: "/")!]) + "../"
if helloPackagesPath.hasPrefix("file://") {
  helloPackagesPath.removeFirst(7)
}

let helloColorPackage: Package.Dependency
if !helloPackagesPath.contains("/DerivedData/") && FileManager.default.fileExists(atPath: "\(helloPackagesPath)hello-app") {
  helloColorPackage = .package(name: "hello-app", path: "\(helloPackagesPath)hello-app")
} else {
  helloColorPackage = .package(url: "https://github.com/hello-apps/hello-app",
                               branch: "main")
}

let dependencies: [Package.Dependency] = [
  helloColorPackage
]

let package = Package(
  name: "AppIconGenerator",
  platforms: [.macOS(.v13)],
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
        .product(name: "HelloApp", package: "hello-app")
      ]),
    .testTarget(
      name: "AppIconGeneratorTests",
      dependencies: ["AppIconGenerator"]),
  ]
)
