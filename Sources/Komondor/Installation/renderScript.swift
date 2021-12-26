/// The *script* part of the script, e.g. the stuff that
/// runs the komodor runner.
///
/// If *this* changes then the template should be updated
///
public func renderScript(_ hookName: String, _ swiftPackagePrefix: String?, _ usingConfigFile: Bool = false) -> String {
    let changeDir = swiftPackagePrefix.map { "cd \($0)\n" }
        ?? ""
  
    let useConfigFile = usingConfigFile ? "--use-config-file" : ""
    return
        """
        hookName=`basename "$0"`
        gitParams="$*"
        \(changeDir)
        # use prebuilt binary if one exists, preferring release
        builds=( '.build/release/komondor' '.build/debug/komondor' )
        for build in ${builds[@]} ; do
          if [[ -e $build ]] ; then
            komondor=$build
            break
          fi
        done
        # fall back to using 'swift run' if no prebuilt binary found
        komondor=${komondor:-'swift run komondor'}

        # run hook
        $komondor run \(hookName) $gitParams \(useConfigFile)
        """
}
