# Komondor

Git Hook automation for Swift and Xcode projects.

<p align="center"><img width ="60%" src="http://dogsaholic.com/wp-content/uploads/2016/06/Komondor-dog.jpg"></p>

A port of [Husky](https://github.com/typicode/husky) to Swift.

### TL:DR

1. Add or amend a `Package.swift`
2. Add this dependency `.package(url: "https://github.com/orta/Komondor.git", from: "0.0.1"),`
3. Run the install command: `swift run komondor install`
4. Add a config section to your `Package.swift`

Then you'll get git-hooks consolidated and centralized so that everyone can work with the same tooling.

### Getting Set up

| [On a SwiftPM project](Documentation/with_swiftpm.md) | [On an Xcode Project](Documentation/only_xcode.md) |
|----------------------------|---------------------------|

