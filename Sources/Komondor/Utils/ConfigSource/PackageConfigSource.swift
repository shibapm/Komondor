import Foundation
import PackageConfig

public struct PackageConfigSource: ConfigSource {
    let logger: Logger

    public init(logger: Logger) {
        self.logger = logger
    }

    public var config: [String: Any] {
        get throws {
            let pkgConfig = try PackageConfiguration.load()

            guard let values = pkgConfig["komondor"] as? [String: Any] else {
                logger.logError("[Komondor] Could not find komondor settings inside the Package.swift")

                exit(1)
            }

            return values
        }
    }
}
