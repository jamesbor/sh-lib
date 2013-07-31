get_terminal_width() {
  echo ${COLUMNS}
}

get_terminal_height() {
  echo ${LINES}
}

get_terminal_country_code() {
  echo ${LANG} | awk -F. '{print $1}'
}

get_terminal_character_set() {
  echo ${LANG} | awk -F. '{print $2}'
}

get_terminal_language() {
  echo ${LANG} | awk -F. '{print $1}' | awk -F_ '{print $1}'
}

get_terminal_country() {
  echo ${LANG} | awk -F. '{print $1}' | awk -F_ '{print $2}'
}

get_cwd() {
  echo ${PWD}
}
