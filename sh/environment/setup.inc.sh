set_env() {
  VAR_TO_SET="$1"
  shift
  VAR_VALUE="$@"
  debugtest
  export "${VAR_TO_SET}"="${VAR_VALUE}"
  debugecho "Set variable: ${VAR_TO_SET} to: ${VAR_VALUE}"
}
