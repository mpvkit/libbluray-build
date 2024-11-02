import Foundation

do {
    let options = try ArgumentOptions.parse(CommandLine.arguments)
    try Build.performCommand(options)

    try BuildFreetype().buildALL()
    try BuildUdfread().buildALL()
    try BuildBluray().buildALL()
} catch {
    print("ERROR: \(error.localizedDescription)")
    exit(1)
}


enum Library: String, CaseIterable {
    case libbluray, libudfread, libfreetype
    var version: String {
        switch self {
        case .libbluray:
            return "1.3.4"
        case .libudfread:
            return "1.1.2"
        case .libfreetype:
            return "0.17.3"
        }
    }

    var url: String {
        switch self {
        case .libbluray:
            return "https://code.videolan.org/videolan/libbluray.git"
        case .libudfread:
            return "https://code.videolan.org/videolan/libudfread.git"
        case .libfreetype:
            return "https://github.com/mpvkit/libass-build/releases/download/\(self.version)/libfreetype-all.zip"
        }
    }

    // for generate Package.swift
    var targets : [PackageTarget] {
        switch self {
        case .libbluray:
            return  [
                .target(
                    name: "Libbluray",
                    url: "https://github.com/mpvkit/libbluray-build/releases/download/\(BaseBuild.options.releaseVersion)/Libbluray.xcframework.zip",
                    checksum: "https://github.com/mpvkit/libbluray-build/releases/download/\(BaseBuild.options.releaseVersion)/Libbluray.xcframework.checksum.txt"
                ),
            ]
        case .libudfread:
            return  [
                .target(
                    name: "Libbluray",
                    url: "https://github.com/mpvkit/libbluray-build/releases/download/\(BaseBuild.options.releaseVersion)/Libudfread.xcframework.zip",
                    checksum: "https://github.com/mpvkit/libbluray-build/releases/download/\(BaseBuild.options.releaseVersion)/Libudfread.xcframework.checksum.txt"
                ),
            ]
        default:
            return []
        }
    }
}


private class BuildBluray: BaseBuild {
    init() {
        super.init(library: .libbluray)

        // 只能 macos 支持 DiskArbitration 框架，其他平台需要注释去掉 DiskArbitration 依赖
    }


    override func arguments(platform: PlatformType, arch: ArchType) -> [String] {
        [
            "--disable-doxygen-doc",
            "--disable-doxygen-dot",
            "--disable-doxygen-html",
            "--disable-doxygen-ps",
            "--disable-doxygen-pdf",
            "--disable-examples",
            "--disable-bdjava-jar",
            "--without-fontconfig",
            "--with-pic",
            "--enable-static",
            "--disable-shared",
            "--disable-fast-install",
            "--disable-dependency-tracking",
            "--host=\(platform.host(arch: arch))",
        ]
    }
}

private class BuildUdfread: BaseBuild {
    init() {
        super.init(library: .libudfread)

        self.pullLatestVersion = true
    }

    override func arguments(platform: PlatformType, arch: ArchType) -> [String] {
        [
            "--with-pic",
            "--enable-static",
            "--disable-shared",
            "--disable-fast-install",
            "--disable-dependency-tracking",
            "--host=\(platform.host(arch: arch))",
        ]
    }
}

private class BuildFreetype: ZipBaseBuild {
    init() {
        super.init(library: .libfreetype)
    }
}