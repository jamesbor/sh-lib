convert_pom_to_ivy() 
{
    test_number_args 1 "$@"					|| return $?
    local POM_FILE="${1}"
    #test_file_has_a_execute_permission ant || return $?
    test_file_good_for_read "${POM_FILE}"			|| return $?
    local IVY_FILE="`file_name ${POM_FILE}`.ivy"
    POM_FILE="`ensure_absolute_path ${POM_FILE}`"
    IVY_FILE="`ensure_absolute_path ${IVY_FILE}`"
    echo " Calling Ant to perform the conversion"
    echo " Executing: ant -f ${SHELL_LIB_HOME}/ant/IvyAndMavenTools.xml -DpomFile=${POM_FILE} -DivyFile=${IVY_FILE} pom-to-ivy"
    test_potential_file_good_for_write "${IVY_FILE}"		|| return $?
    ant -f ${SHELL_LIB_HOME}/ant/IvyAndMavenTools.xml -DpomFile=${POM_FILE} -DivyFile=${IVY_FILE} pom-to-ivy
    test_file_is_not_empty "${IVY_FILE}"			|| return $?
}

convert_ivy_to_pom() 
{
    test_number_args 1 $@					|| return $?
    local IVY_FILE="${1}"
    test_file_executable ant
    echo you wont see this is we ran
}
