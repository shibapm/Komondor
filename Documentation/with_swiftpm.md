### Already using SwiftPM

1. Add the dependency to your `Package.swift`.
2. Set up the git-hooks for `komondor` via [`PackageConfig`](https://github.com/orta/PackageConfig#packageconfig)

```diff
// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "Komondor",
    products: [ ... ],
    dependencies: [
        // My dependencies
        .package(url: "https://github.com/orta/PackageConfig.git", from: "0.0.1"),
        // Dev deps
+        .package(url: "https://github.com/orta/Komondor.git", from: "0.0.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.35.8"),
    ],
    targets: [...]
)

+ #if canImport(PackageConfig)
+     import PackageConfig
+ 
+     let config = PackageConfig([
+         "komondor": [
+             "pre-commit": ["swift test", "swift run swiftFormat .", "git add ."],
+             "pre-push": "swift test"
+         ],
+     ])
+ #endif
```

You can get more information on the [config here](./config.md).
