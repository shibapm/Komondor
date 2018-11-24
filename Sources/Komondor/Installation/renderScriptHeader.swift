import Foundation

/// The *script* part of the script, e.g. the stuff that
/// runs the komodor runner.
///
/// If *this* changes then the template should be updated
///
public func renderScriptHeader(_: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    let installDate = dateFormatter.string(from: Date())

    return
        """
        #!/bin/sh
        # Komondor v\(KomondorVersion)
        # Installed: \(installDate)

        """
}
