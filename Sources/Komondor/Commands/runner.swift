import Foundation
import PackageConfig
import ShellOut

// To emulate running the command as the script would do:
//
// swift run komondor run [hook-name]
//
//
public func runner(logger _: Logger, args: [String]) throws {
    let pkgConfig = try PackageConfiguration.load()

    guard let hook = args.first else {
        logger.logError("[Komondor] The runner was called without a hook")
        exit(1)
    }

    guard let config = pkgConfig["komondor"] as? [String: Any] else {
        logger.logError("[Komondor] Could not find komondor settings inside the Package.swift")
        exit(1)
    }

    guard let hookOptions = config[hook] else {
        logger.logError("[Komondor] Could not find a key for '\(hook)' under the komondor settings'")
        exit(1)
    }

    var commands: [String] = []
    if let stringOption = hookOptions as? String {
        commands = [stringOption]
    } else if let arrayOptions = hookOptions as? [String] {
        commands = arrayOptions
    }

    logger.debug("Running commands for komondor \(commands.joined())")
    let stagedFiles = try getStagedFiles()

    do {
        try commands.forEach { command in
            print("[Komondor] > \(hook) \(command)")
            let gitParams = Array(args.dropFirst())
            let expandedCommand = expandEdited(forCommand: command, withFiles: stagedFiles)

            // Exporting git hook input params as shell env var GIT_PARAMS
            let cmd = "export GIT_PARAMS=\(gitParams.joined(separator: " ")) ; \(expandedCommand)"
            // Simple is fine for now
            print(try shellOut(to: cmd))
            // Ideal:
            //   Store STDOUT and STDERR, and only show it if it fails
            //   Show a stepper like system of all commands
        }
    } catch let error as ShellOutError {
        print(error.message)
        print(error.output)

        let noVerifyMessage = skippableHooks.contains(hook) ? "add --no-verify to skip" : "cannot be skipped due to Git specs"
        print("[Komondor] > \(hook) hook failed (\(noVerifyMessage))")
        exit(error.terminationStatus)
    } catch {
        print(error)
        exit(1)
    }
}

func getStagedFiles() throws -> [String] {
    // Find the project root directory
    let projectRootString = try shellOut(to: "git rev-parse --show-toplevel").trimmingCharacters(in: .whitespaces)
    logger.debug("Found project root at: \(projectRootString)")

    let stagedFilesString = try shellOut(to: "git", arguments: ["diff", "--staged", "--diff-filter=ACM", "--name-only"], at: projectRootString)
    logger.debug("Found staged files: \(stagedFilesString)")

    return stagedFilesString == "" ? [] : stagedFilesString.components(separatedBy: "\n")
}

func expandEdited(forCommand command: String, withFiles files: [String]) -> String {
    guard let exts = parseEdited(command: command) else {
        return command
    }

    let matchingFiles = files.filter { file in
        exts.contains(where: { ext in
            file.hasSuffix(".\(ext)")
        })
    }

    return command.replacingOccurrences(of: editedRegexString, with: matchingFiles.joined(separator: " "), options: .regularExpression)
}
