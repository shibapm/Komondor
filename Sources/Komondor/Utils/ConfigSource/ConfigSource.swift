import Foundation

public protocol ConfigSource {
    var config: [String: Any] { get throws }
}
