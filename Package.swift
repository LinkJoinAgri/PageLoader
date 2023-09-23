// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PageLoader",
    products: [
        .library(name: "PageLoader", targets: ["PageLoader"]),
    ],
    targets: [
        .target(name: "PageLoader"),
        .testTarget(name: "PageLoaderTests", dependencies: ["PageLoader"]),
    ]
)
