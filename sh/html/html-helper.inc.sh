#!/bin/sh
html_header() {
  echo "Content-type: text/html"
  echo ""
}

html_header_nocache() {
  echo -n -e "Content-type: text/html\n"
  echo -n -e "Cache-control: no-cache\n"
  echo -n -e "Pragma: no-cache\n"
  echo ""
}

html_header_nocache_notype() {
  echo -n -e "Cache-control: no-cache\n"
  echo -n -e "Pragma: no-cache\n"
  echo ""
}

html_open() {
  TITLE="${@}"
  echo ""
  echo "<html>"
  echo "  <head>"
  echo "    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
  echo "    <link rel=\"shortcut icon\" href=\"/favicon.ico\" />"
  if [ -n "${STYLESHEET}" ]
  then
    echo "    <link href=\"${STYLESHEET}\" rel=\"stylesheet\" type=\"text/css\">"
  fi
  echo "    <title>${TITLE}</title>"
  echo "  </head>"
  echo "  <body>"
}

html_close() {
  echo "  </body>"
  echo "</html>"
  exit 0
}

html_h1() {
  HEADING="${@}"
  echo "    <h1>${HEADING}</h1>"
}

html_h2() {
  HEADING="${@}"
  echo "    <h2>${HEADING}</h2>"
}

html_h3() {
  HEADING="${@}"
  echo "    <h3>${HEADING}</h3>"
}

html_p() {
  P_TEXT="${@}"
  echo "    <p>${P_TEXT}</p>"
}

html_li() {
  LI_TEXT="${@}"
  echo "    <li>${LI_TEXT}</li>"
}

html_opentag() {
  TAG="${1}"
  echo "    <${TAG}>"
}

html_closetag() {
  TAG="${1}"
  echo "    </${TAG}>"
}

html_wraptag_text() {
  TAG="${1}"
  shift
  ARGS_TO_BE_WRAPPED="${@}"
  html_opentag ${TAG}
  echo ${ARGS_TO_BE_WRAPPED}
  html_closetag ${TAG}
}

html_wraptag_execute() {
  TAG="${1}"
  shift
  ARGS_TO_BE_WRAPPED="${@}"
  html_opentag ${TAG}
  ${ARGS_TO_BE_WRAPPED}
  html_closetag ${TAG}
}
