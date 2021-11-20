import Foundation
import ShellOut
import Yams

public struct FileConfigSource: ConfigSource {
    let logger: Logger

    public init(logger: Logger) {
        self.logger = logger
    }

    public var config: [String: Any] {
        get throws {
            let path = try shellOut(to: "git rev-parse --show-toplevel")
                .trimmingCharacters(in: .whitespaces)
                .appending("/komondor.yml")

            let yaml = try String(contentsOfFile: path)
            let config = try Yams.load(yaml: yaml)

            guard let config = config as? [String: Any] else {
                logger.logError("[Komondor] Could not load komondor configuration from file at \(path)")

                exit(1)
            }

            return config
        }
    }
}
