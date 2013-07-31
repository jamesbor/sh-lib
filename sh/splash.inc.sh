welcome_message() {
  cat ${SHELL_LIB_HOME}/txt/splash.txt
}

game_over() {
  cat ${SHELL_LIB_HOME}/txt/game-over.txt
  echo
}

weight_lift() {
  cat ${SHELL_LIB_HOME}/txt/weight-lift.txt
  echo
}

weight_lift_fail() {
  cat ${SHELL_LIB_HOME}/txt/weight-lift-fail.txt
  echo
}

startup_splash() {
    welcome_message
    report_arguments "$@"
    report_path
    report_ldlibrary_path
    report_environment
}
