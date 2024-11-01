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
            url: "https://github.com/mpvkit/libbluray-build/releases/download/1.3.4/Libbluray.xcframework.zip",
            checksum: "f3f50ca2948f9983247c3d00faee92aab168501579edcf610d80312a252e5ff5"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)