/// The *script* part of the script, e.g. the stuff that
/// runs the komodor runner.
///
/// If *this* changes then the template should be updated
///
public func renderScript(_ hookName: String, _ swiftPackagePath: String) -> String {
    return
        """
        hookName=`basename "$0"`
        gitParams="$*"

        if grep -q \(hookName) \(swiftPackagePath); then
          swift run komondor run \(hookName)
        fi
        """
}
