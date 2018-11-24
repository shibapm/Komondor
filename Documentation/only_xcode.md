### Xcode only install

Whoah, so, welcome to using Swift Package Manager (SwiftPM). Given work in SwiftPM has so far been focused on 
server-side Swift,  it's not really had wide-spread adoption, but a lot of the useful third-party eco-system tools
support it:

 - [danger-swift](https://github.com/danger/swift)
 - [swiftlint](https://github.com/realm/swiftlint)
 - [swiftformat](https://github.com/nicklockwood/SwiftFormat)

and... well...

 - [komondor](https://github.com/orta/Komondor)

Maybe there's enough support that now is the time to move these sort of dependencies into a package manager.

### Getting started

To get started, you need to be on a Mac with Xcode 10+ installed. This means you already have Swift
Package Manager available.

The `Package.swift` file is basically the same thing as a Podfile + Podspec combined, it combines all of 
your app and tooling dependencies in one places.

Because we're not going to be using Swift PM for building apps/libraries/etc then the default template isn't
useful for us.

```swift
// swift-tools-version:4.2
// Declares the tooling version of your Package.swift
// (you may need to update this number)

import PackageDescription

let package = Package(
    name: "[your app]",
    dependencies: [
      .package(url: "https://github.com/orta/Komondor.git", from: "0.0.1")
    ]
)
```

This adds `Komondor` to the app, and allows you to run the CLI for Komondor, you can verify by running 
`swift run komondor` and seeing the help message.

Next up: adding your git hooks to the config:

```diff
      .package(url: "https://github.com/orta/Komondor.git", from: "0.0.1")
    ]
)

+ #if canImport(PackageConfig)
+     import PackageConfig
+ 
+     let config = PackageConfig([
+         "komondor": [
+             "pre-commit": "echo 'Hi'"
+         ],
+     ])
+ #endif
```

This config is `"[git hook]": ["command"]`, you can read [more here](./config.md). 

Final step: run `swift run komondor install`, this will set up your git-hooks. If you `git add .` and 
`git commit -m "Added Komondor" to the app, it will run the git-hooks and echo "Hi" to the terminal.
