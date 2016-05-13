node {
    // Mark the code build 'stage'....
    stage 'Build'
    checkout scm
    // Run the maven build
    sh "./gradlew clean fatJar"

    def image = docker.build("labisso/hello-karyon-rxnetty")
    image.push()

    stage 'Integration'

    // this is where real int tests would go
    sh "echo Completed Krayon Integration test"

    input 'Proceed to QA?'

    stage 'QA'

    sh "echo Deploy Terraform environment"

    sh "echo Deploy Container with Nomad"

    sh "echo Run QA tests"


    input 'Deploy to Prod?'

}