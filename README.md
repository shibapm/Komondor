<p align="center"><a href='https://www.akc.org/dog-breeds/komondor/'><img width ="100%" src="http://dogsaholic.com/wp-content/uploads/2016/06/Komondor-dog.jpg"><a/></p>

# Komondor

Git Hook automation for Swift and Xcode projects. A port of [Husky](https://github.com/typicode/husky) to Swift.

### TL:DR

1. Add or amend a `Package.swift`
2. Add this dependency `.package(url: "https://github.com/orta/Komondor.git", from: "1.0.0"),`
3. Run the install command: `swift run komondor install`
4. Add a config section to your [`Package.swift`](https://github.com/orta/Komondor/blob/master/Package.swift)

Then you'll get git-hooks consolidated and centralized so that everyone can work with the same tooling.

### Why?

> If you care about something, you should automate it.

Git Hooks like what Komondor provides gives you more surface area for per-project automation. Komondor provides
an easily understood way to see how all the git automation touch-points in your project will come together. These 
hooks allow for much faster feedback during development and let different team-members to use different tools
but still have the same bar of quality.

For example, adding [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) to your `pre-commit` hook means that
no-one will ever need to discuss formatting in code review again. Perfect. It won't slow down your Xcode builds, 
because it lives outside of your project and you can verify it on CI if you'd like to be 100% that everyone conforms.

Another example, running tests before pushing - this means you don't have to come back 10-15m later once CI has told
you that you have a failing test. This moves more validation to a point where you are still in-context.

### An Example

This is from [the repo](https://github.com/orta/Komondor/blob/master/Package.swift) you're looking at:

```swift
#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfig([
        "komondor": [
            "pre-push": "swift test",
            "pre-commit": [
                "swift test",
                "swift run swiftFormat .",
                "swift run swiftlint autocorrect --path Sources/",
                "git add .",
            ],
        ],
    ]).write()
#endif
```

See more about the [config here](./Documentation/config.md).

### Getting Set up

| [On a SwiftPM project](Documentation/with_swiftpm.md) | [On an Xcode Project](Documentation/only_xcode.md) |
|----------------------------|---------------------------|

### Deployment

Use `swift run rocket [patch]`
