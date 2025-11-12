import Foundation

do {
    let options = try ArgumentOptions.parse(CommandLine.arguments)
    try Build.performCommand(options)

    try BuildOpenSSL().buildALL()
    try BuildFreetype().buildALL()
    try BuildBluray().buildALL()
} catch {
    print("ERROR: \(error.localizedDescription)")
    exit(1)
}


enum Library: String, CaseIterable {
    case libbluray, openssl, libfreetype
    var version: String {
        switch self {
        case .libbluray:
            return "1.3.4"
        case .openssl:
            return "3.3.2-xcode"
        case .libfreetype:
            return "0.17.3-xcode"
        }
    }

    var url: String {
        switch self {
        case .libbluray:
            return "https://code.videolan.org/videolan/libbluray.git"
        case .openssl:
            return "https://github.com/mpvkit/openssl-build/releases/download/\(self.version)/openssl-all.zip"
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

private class BuildOpenSSL: ZipBaseBuild {
    init() {
        super.init(library: .openssl)
    }
}

private class BuildFreetype: ZipBaseBuild {
    init() {
        super.init(library: .libfreetype)
    }
}
