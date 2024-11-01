import Foundation

do {
    let options = try ArgumentOptions.parse(CommandLine.arguments)
    try Build.performCommand(options)

    try BuildFreetype().buildALL()
    try BuildBluray().buildALL()
} catch {
    print("ERROR: \(error.localizedDescription)")
    exit(1)
}


enum Library: String, CaseIterable {
    case libbluray, libfreetype
    var version: String {
        switch self {
        case .libbluray:
            return "1.3.4"
        case .libfreetype:
            return "0.17.3"
        }
    }

    var url: String {
        switch self {
        case .libbluray:
            return "https://code.videolan.org/videolan/libbluray.git"
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
            break
        }
    }
}


private class BuildBluray: BaseBuild {
    init() {
        super.init(library: .libbluray)
    }

    override func beforeBuild() throws {
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            return 
        }

        // pull code from git
        let noPatchURL = directoryURL + "nopatch"
        try! Utility.launch(path: "/usr/bin/git", arguments: ["-c", "advice.detachedHead=false", "clone", "--recursive", "--depth", "1", "--branch", library.version, library.url, noPatchURL.path])

        let patchURL = directoryURL + "patch"
        try! Utility.launch(path: "/usr/bin/git", arguments: ["-c", "advice.detachedHead=false", "clone", "--recursive", "--depth", "1", "--branch", library.version, library.url, patchURL.path])
        // apply patch
        let patch = URL.currentDirectory + "../Sources/BuildScripts/patch/\(library.rawValue)"
        if FileManager.default.fileExists(atPath: patch.path) {
            _ = try? Utility.launch(path: "/usr/bin/git", arguments: ["checkout", "."], currentDirectoryURL: patchURL)
            let fileNames = try! FileManager.default.contentsOfDirectory(atPath: patch.path).sorted()
            for fileName in fileNames {
                try! Utility.launch(path: "/usr/bin/git", arguments: ["apply", "\((patch + fileName).path)"], currentDirectoryURL: patchURL)
            }
        }
    }

    override func configure(buildURL: URL, environ: [String: String], platform: PlatformType, arch: ArchType) throws {
        // 只能 macos 支持 DiskArbitration 框架，其他平台使用 patch 版本去掉 DiskArbitration 依赖
        var workURL = directoryURL + "nopatch"
        if platform != .macos && platform != .maccatalyst {
            workURL = directoryURL + "patch"
        }

        let configure = workURL + "configure"
        if !FileManager.default.fileExists(atPath: configure.path) {
            var bootstrap = workURL + "bootstrap"
            if !FileManager.default.fileExists(atPath: bootstrap.path) {
                bootstrap = workURL + ".bootstrap"
            }
            if FileManager.default.fileExists(atPath: bootstrap.path) {
                try Utility.launch(executableURL: bootstrap, arguments: [], currentDirectoryURL: workURL, environment: environ)
            }
        }
        var arguments = [
            "--prefix=\(thinDir(platform: platform, arch: arch).path)",
        ]
        arguments.append(contentsOf: self.arguments(platform: platform, arch: arch))
        try Utility.launch(executableURL: configure, arguments: arguments, currentDirectoryURL: buildURL, environment: environ)
    }

    override func arguments(platform: PlatformType, arch: ArchType) -> [String] {
        [
            "--with-libudfread",
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


private class BuildFreetype: ZipBaseBuild {
    init() {
        super.init(library: .libfreetype)
    }
}