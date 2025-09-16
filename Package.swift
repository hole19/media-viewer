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
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.0.0"),
        .package(url:  "https://github.com/Quick/Nimble.git", from: "13.0.0")
    ],
    targets: [
        .target(
            name: "H19MediaViewer",
            dependencies: ["SDWebImage"],
            path: "H19MediaViewer",
            resources: []
        ),
        .testTarget(
            name: "H19MediaViewerTests",
            dependencies: [
                "H19MediaViewer",
                "Nimble"
            ],
            path: "H19MediaViewerTests"
        )
    ]
)
