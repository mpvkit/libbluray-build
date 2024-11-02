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
            dependencies: ["Libbluray", "Libudfread"],
            path: "Sources/_Dummy"
        ),
        //AUTO_GENERATE_TARGETS_BEGIN//

        .binaryTarget(
            name: "Libudfread",
            url: "https://github.com/mpvkit/libbluray-build/releases/download/1.3.4/Libudfread.xcframework.zip",
            checksum: "30c9c3cfe9be26de4bb3f502dc26ceb4542214909cc547be7b02732dd1ac3693"
        ),

        .binaryTarget(
            name: "Libbluray",
            url: "https://github.com/mpvkit/libbluray-build/releases/download/1.3.4/Libbluray.xcframework.zip",
            checksum: "36c6463535b467eb2205a862d14030431848e08d4ac056c10f5da48a9c8123a8"
        ),
        //AUTO_GENERATE_TARGETS_END//
    ]
)