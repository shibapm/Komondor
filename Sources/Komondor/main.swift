import Foundation

/// Version for showing in verbose mode
public let KomondorVersion = "1.0.0"

let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
let isSilent = CommandLine.arguments.contains("--silent")
let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)
logger.debug("Setting up .git-hooks for Komondor (v\(KomondorVersion))")

let cliLength = ProcessInfo.processInfo.arguments.count

if cliLength > 1 {
    let task = CommandLine.arguments[1]
    if task == "install" {
        try install(logger: logger)
    } else if task == "run" {
        let runnerArgs = Array(CommandLine.arguments.dropFirst().dropFirst())
        try runner(logger: logger, args: runnerArgs)
    }
} else {
    print("""
    Welcome to Komondor, it has 2 commands:

      - `swift run komondor install` sets up your git repo to use Komondor
      - `swift run komondor run` used by the git-hooks to run your hooks

    Docs are available at: https://github.com/orta/Komondor
    """)
}
