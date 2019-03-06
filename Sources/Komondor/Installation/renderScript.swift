/// The *script* part of the script, e.g. the stuff that
/// runs the komodor runner.
///
/// If *this* changes then the template should be updated
///
public func renderScript(_ hookName: String, _ swiftPackagePath: String, _ komondorProductPath: String?) -> String {
    let runKomondorCmd = komondorProductPath ?? "swift run komondor"
    return
        """
        hookName=`basename "$0"`
        gitParams="$*"

        if grep -q \(hookName) \(swiftPackagePath); then
          \(runKomondorCmd) run \(hookName)
        fi
        """
}
