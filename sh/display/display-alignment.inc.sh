#pad_left() {
# WIDTH=${1}
# shift
# echo $@ | awk ' { fmt = sprintf("%%-%ds", WIDTH); printf fmt, $0; } ' WIDTH=${WIDTH}
#}


# pad_right(WIDTH, STRING)
#pad_right() {
# WIDTH=${1}
# shift
# echo $@ | awk ' { fmt = sprintf("%%%ds", WIDTH); printf fmt, $0; } ' WIDTH=${WIDTH}
#}

echo_left() {
  # Echo all args given to the function with a right alignment on your terminal.
  # This function uses the COLUMNS env var, so, first lets call env_ensure_COLUMNS to make sure it is set
  # This could be considered a convenience method as echo is very similar, however, this should result in padding
  # with whitespace as well
  env_ensure_COLUMNS
  echo $@ | awk ' { fmt = sprintf("%%-%ds", WIDTH); printf fmt, $0; } ' WIDTH=${COLUMNS}
}

echo_right() {
  # Echo all args given to the function with a right alignment on your terminal.
  # This function uses the COLUMNS env var, so, first lets call env_ensure_COLUMNS to make sure it is set
  env_ensure_COLUMNS
  echo $@ | awk ' { fmt = sprintf("%%%ds", WIDTH); printf fmt, $0; } ' WIDTH=${COLUMNS}
}
