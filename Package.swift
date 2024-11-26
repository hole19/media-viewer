// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "H19MediaViewer",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "H19MediaViewer",
            targets: ["H19MediaViewer"]
        )
    ],
    targets: [
        .target(
            name: "H19MediaViewer",
            path: "H19MediaViewer",
            exclude: ["Tests"],
            resources: []
        ),
        .testTarget(
            name: "H19MediaViewerTests",
            dependencies: ["H19MediaViewer"],
            path: "Tests"
        )
    ]
)
