// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftStride",
    platforms: [.iOS(.v9),.macOS(.v10_10)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftStride",
            targets: ["SwiftStride"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "CStride",
                dependencies: [],
                path: "Sources/Stride"),
        .target(
            name: "SwiftStride",
            dependencies: [.target(name: "CStride")],
            path: "Sources/Swift"),
        .testTarget(name: "StrideTests", dependencies: [.target(name: "SwiftStride")])
    ]
)
