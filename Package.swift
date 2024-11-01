// swift-tools-version:5.9
import PackageDescription

let package = Package(
   name: "PersistenceKit",
   platforms: [
      .macOS(.v14), // macOS 14 and later
      .iOS(.v17), // iOS 17 and later
   ],
   products: [
      .library(
         name: "PersistenceKit",
         targets: ["PersistenceKit"]),
   ],
   dependencies: [
      .package(url: "https://github.com/eonist/UserDefaultSugar", branch: "master"),
      .package(url: "https://github.com/sentryco/Key", branch: "main")
   ],
   targets: [
      .target(
         name: "PersistenceKit",
         dependencies: [ "Key", "UserDefaultSugar"]),
      .testTarget(
         name: "PersistenceKitests",
         dependencies: ["PersistenceKit"]),
   ]
)

