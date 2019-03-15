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
          $komondor run \(hookName)
        fi
        """
}
