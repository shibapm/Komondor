import Foundation
import PackageConfig
import ShellOut

// To emulate running the command as the script would do:
//
// swift run komondor run [hook-name]
//
public func runner(logger _: Logger, args: [String], exitFunc: (_: Int32) -> Never) throws {
    let pkgConfig = getPackageConfig()

    guard let hook = args.first else {
        logger.logError("[Komondor] The runner was called without a hook")
        exit(1)
    }

    guard let config = pkgConfig["komondor"] else {
        logger.logError("[Komondor] Could not find komondor settings inside the Package.swift")
        exit(1)
    }

    guard let hookOptions = config[hook] else {
        logger.logError("[Komondor] Could not find a key for '\(hook)' under the komondor settings'")
        exit(1)
    }

    var commands = [] as [String]
    if let stringOption = hookOptions as? String {
        commands = [stringOption]
    } else if let arrayOptions = hookOptions as? [String] {
        commands = arrayOptions
    }

    logger.debug("Running commands git hook: \(commands.joined())")

    do {
        try commands.forEach { command in
            logger.logInfo("> \(command)")
            // Simple is fine for now
            try shellOut(to: command)
        }
    } catch {
        guard let error = error as? ShellOutError else { return }
        logger.logError(error.message) // Prints STDERR
        logger.logError(error.output) // Prints STDOUT

        if skippableHooks.contains(hook) {
            logger.logInfo("\n You can skip this hook by adding --no-validate if you need to")
        }

        // Fail the git hook
        exitFunc(1)
    }
    // Passed
    exitFunc(0)
}
