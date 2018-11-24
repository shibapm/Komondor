### Available options

Today you can hook into all of the following git-hooks:

```swift
let hookList = [
    "applypatch-msg",
    "pre-applypatch",
    "post-applypatch",
    "pre-commit",
    "prepare-commit-msg",
    "commit-msg",
    "post-commit",
    "pre-rebase",
    "post-checkout",
    "post-merge",
    "pre-push",
    "pre-receive",
    "update",
    "post-receive",
    "post-update",
    "push-to-checkout",
    "pre-auto-gc",
    "post-rewrite",
    "sendemail-validate",
]
```

These are all keys you can use in the config setting:

```swift
#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfig([
        "komondor": [
            "pre-commit": ["swift test", "swift run swiftFormat .", "git add ."],
            "pre-push": ["swift test", swift run danger-swift local", "swift run swiftlint"]
        ],
    ])
#endif
```
