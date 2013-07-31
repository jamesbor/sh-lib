external_maven_generate_hello_world()
{
    mvn archetype:generate				\
    -DarchetypeGroupId=org.apache.maven.archetypes	\
    -DgroupId=com.mycompany.app				\
    -DartifactId=my-app
}
