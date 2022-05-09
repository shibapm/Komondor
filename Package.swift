// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Komondor",
    products: [
        .executable(name: "komondor", targets: ["Komondor"]),
    ],
    dependencies: [
        // User deps
        .package(url: "https://github.com/shibapm/PackageConfig.git", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.1.0"),
        // Dev deps
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.35.8"), // dev
        .package(url: "https://github.com/Realm/SwiftLint.git", from: "0.28.1"), // dev
        .package(url: "https://github.com/shibapm/Rocket", from: "1.2.1"), // dev
    ],
    targets: [
        .target(
            name: "Komondor",
            dependencies: ["PackageConfig", "ShellOut"]
        ),
    ]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-push": "swift build",
            "pre-commit": [
                "swift build",
                "swift run swiftformat .",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
        "rocket": [
            "after": [
                "push",
            ],
        ],
    ]).write()
#endif
