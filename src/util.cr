module Util
  extend self

  # Determine whether the system is set up to run `mtenv`. If it is not, abort
  # execution and inform the user of their installation problems.
  def require_setup!
    Dir.exists?(MTENV.home) || fail_setup!("`#{MTENV.home}` directory does not exist.")
    Dir.exists?(MTENV.from_home("versions")) || fail_setup!("`#{MTENV.from_home("versions")}` directory does not exist.")
    File.exists?(MTENV.from_home("shims_dir")) || fail_setup!("`#{MTENV.from_home("shims_dir")}` reference file does not exist.")
  end


  # Determine whether `version` is "versionish". That is, that it is able to
  # indicate a specific version of Myst to install. This includes semver
  # version numbers and commit SHAs, among potential others.
  #
  # The input is expected to already be trimmed.
  #
  # Returns true if `version` satisifies that condition, false otherwise.
  def versionish?(version)
    is_version = false
    [
      # SemVer release numbers:
      #  v0.0.1
      #  v1.0.2
      #  v12.52.12
      /^v\d+\.\d+\.\d+$/,
      # commit SHAs (must be at least 7 characters long)
      #  546c2877be8b58a668bd724a936a55c2c80e0308
      /^[0-9a-fA-F]{7,40}$/
    ].any?{ |re| re.match(version) } || false
  end

  def fail!(message, status=1)
    abort message, status
  end

  def fail_setup!(message)
    fail! <<-MSG
      Setup check failed! Cause:
      #{message}

      `mtenv` requires a valid setup to run.
      Run `mtenv setup` to attempt an automatic fix.
    MSG
  end
end
