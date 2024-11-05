// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "libbluray",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: [
        .library(name: "Libbluray", targets: ["_Libbluray"]),
    ],
    targets: [
        // Need a dummy target to embedded correctly.
        // https://github.com/apple/swift-package-manager/issues/6069
        .target(
            name: "_Libbluray",
            dependencies: ["Libbluray"],
            path: "Sources/_Dummy"
        ),
        //AUTO_GENERATE_TARGETS_BEGIN//

        .binaryTarget(
            name: "Libbluray",
            url: "https://github.com/mpvkit/libbluray-build/releases/download/1.3.4-nav/Libbluray.xcframework.zip",
            checksum: "f097bc17fed1479744c2e44ffd24e3b43a7448b627c9b2bace9ac8a5b81d17b2"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)