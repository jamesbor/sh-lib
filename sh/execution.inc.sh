execute_log_state () {
  COMMAND_TO_RUN="$@"
  echo "Running: ${COMMAND_TO_RUN}"
  ${COMMAND_TO_RUN}
  if [ $? == 0 ]
  then
    echo "Success in running ${COMMAND_TO_RUN}"
  else
    echo "Failed running ${COMMAND_TO_RUN} ($?)"
  fi
}

report_execution_state_last_command() {
  PREV_EXT=$?; PREV_CMD="`history | tail -2 | head -1`" ; if [ "${PREV_EXT}" -eq "0" ]; then echo " Command with PID: ${PREV_CMD} was successful"; else echo " Command with PID: ${PREV_CMD} FAILED! :("; fi
}
