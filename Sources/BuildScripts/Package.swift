// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "build",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "build", targets: ["build"])
    ],
    dependencies: [
        .package(url: "https://github.com/mpvkit/BuildShared.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "build",
            dependencies: ["BuildShared"],
            path: "XCFrameworkBuild"
        )
    ]
)
