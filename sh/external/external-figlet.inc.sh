externalFigletGetFonts()
{
    local FIGLET_FONT_URL="ftp://ftp.figlet.org/pub/figlet/fonts/ours.tar.gz"
    httpGetToFile "${FIGLET_FONT_URL}" 
}
