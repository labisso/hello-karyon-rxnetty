node {

    stage 'Build'
    checkout scm
    sh "./gradlew clean fatJar"
    def image = docker.build("labisso/hello-karyon-rxnetty")
    image.push()


    stage 'Integration'

    // this is where real int tests would go
    sh "echo Completed Krayon Integration test"

    input 'Proceed to QA?'

    stage 'QA'

    sh "echo Deploy Terraform environment"

    git changelog: false, credentialsId: 'cf983439-429f-4d36-a27d-ae8d29dda57b', poll: false, url: 'https://git.labs.dell.com/scm/trn/terraform-nomad.git', relativeTargetDir: 'terraform-nomad'


    sh "echo Deploy Container with Nomad"

    sh "echo Run QA tests"


    input 'Deploy to Prod?'

}