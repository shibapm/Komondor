import Foundation
import ShellOut

/// The available hooks for git
///
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
    "sendemail-validate"
]

let skippableHooks = [
    "commit-msg",
    "pre-commit",
    "pre-rebase",
    "pre-push"
]

public func install(logger _: Logger) throws {
    // Add a skip env var
    let env = ProcessInfo.processInfo.environment
    if env["SKIP_KOMONDOR"] != nil {
        logger.logInfo("Skipping Komondor integration due to SKIP_KOMONDOR being set")
        return
    }

    // Check for CI
    if env["CI"] != nil {
        logger.logInfo("Skipping Komondor integration due to CI being set")
        return
    }

    // Validate we're in a git repo
    do {
        try shellOut(to: "git remote")
    } catch {
        logger.logError("[Komondor] Can only install git-hooks into a git repo.")
        exit(1)
    }

    let fileManager = FileManager.default

    // Find the .git root
    let gitRootString = try shellOut(to: "git rev-parse --git-dir").trimmingCharacters(in: .whitespaces)
    logger.debug("Found git root at: \(gitRootString)")

    // Find or create the hooks dir in the .git folder
    var hooksRoot = URL(fileURLWithPath: gitRootString)
    hooksRoot.appendPathComponent("hooks", isDirectory: true)

    if !fileManager.fileExists(atPath: hooksRoot.path) {
        logger.debug("Making the hooks dir")
        try shellOut(to: .createFolder(named: hooksRoot.path))
    }

    // TODO: What if Package.swift isn't in the CWD?
    let swiftPackagePath = "Package.swift"

    // Copy in the komondor templates
    try hookList.forEach { hookName in
        var hookPath = URL(fileURLWithPath: hooksRoot.absoluteString)
        hookPath.appendPathComponent(hookName)

        // Separate header from script so we can
        // update if the script updates
        let header = renderScriptHeader(hookName)
        let script = renderScript(hookName, swiftPackagePath)
        let hook = header + script

        // This is the same permissions that husky uses
        let execAttribute: [FileAttributeKey: Any] = [
            .posixPermissions: 0o755
        ]

        // Create it if it's not there
        if !fileManager.fileExists(atPath: hookPath.path) {
            logger.debug("Added the hook: \(hookName)")
            fileManager.createFile(atPath: hookPath.path, contents: hook.data(using: .utf8), attributes: execAttribute)
        } else {
            // Check if the script part has had an update since last running install
            let existingFileData = try Data(contentsOf: hookPath, options: [])
            let content = String(data: existingFileData, encoding: .utf8)!

            if content.contains(script) {
                logger.debug("Skipped the hook: \(hookName)")
            } else {
                logger.debug("Updating the hook: \(hookName)")
                fileManager.createFile(atPath: hookPath.path, contents: hook.data(using: .utf8), attributes: execAttribute)
            }
        }
    }
    print("[Komondor] git-hooks installed")
}
