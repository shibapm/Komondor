import Foundation

/// Version for showing in verbose mode
public let KomondorVersion = "1.0.0"

let isVerbose = CommandLine.arguments.contains("--verbose") || (ProcessInfo.processInfo.environment["DEBUG"] != nil)
let isSilent = CommandLine.arguments.contains("--silent")
let isUsingConfigFile = CommandLine.arguments.contains("--use-config-file")

let logger = Logger(isVerbose: isVerbose, isSilent: isSilent)
logger.debug("Setting up .git-hooks for Komondor (v\(KomondorVersion))")

let cliLength = ProcessInfo.processInfo.arguments.count

guard cliLength > 1 else {
    print("""
    Welcome to Komondor, it has 3 commands:

      - `swift run komondor install` sets up your git repo to use Komondor
      - `swift run komondor run` used by the git-hooks to run your hooks
      - `swift run komondor uninstall` removes git-hooks created by Komondor

    Docs are available at: https://github.com/shibapm/Komondor
    """)
    exit(0)
}

let task = CommandLine.arguments[1]

switch task {
case "install":
    try install(logger: logger, usingConfigFile: isUsingConfigFile)
case "run":
    let configSource: ConfigSource = isUsingConfigFile ? FileConfigSource(logger: logger) : PackageConfigSource(logger: logger)
    let runnerArgs = Array(CommandLine.arguments.dropFirst().dropFirst())
    try runner(logger: logger, configSource: configSource, args: runnerArgs)
case "uninstall":
    try uninstall(logger: logger)
default:
    logger.logError("command not recognised")
    exit(1)
}
