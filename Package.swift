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
            url: "https://github.com/mpvkit/libbluray-build/releases/download/1.4.0/Libbluray.xcframework.zip",
            checksum: "bc037d34e2b0b5ab7f202fb371f5fb298136cc66fdf406c2172185d06f53f18d"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)