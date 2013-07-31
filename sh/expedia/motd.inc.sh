motd_artifactory() {
  figlet -c -f slant Artifactory -w 80
  figlet -c ${1} -w 80
}

motd_artifactory_create_country() {
  for SITE in UK USA SZE BUD
  do
    motd_artifactory ${SITE} > motd.${SITE}
  done
}
