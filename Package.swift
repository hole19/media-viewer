// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "H19MediaViewer",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "H19MediaViewer", targets: ["H19MediaViewer"])
    ],
    targets: [
        .target(name: "H19MediaViewer"),
        .testTarget(
            name: "H19MediaViewerTests",
            dependencies: ["H19MediaViewer"]
        )
    ]
)
