import groovy.json.JsonSlurper
import groovy.json.JsonOutput

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
    writeTerraformVars("terraform.tfvars.json", "dsg/jenkinsnomad1")


    sh "echo Deploy Container with Nomad"

    sh "echo Run QA tests"

    input 'Deploy to Prod?'

}

def writeTerraformVars(path, atlasName) {
    withCredentials([[$class: 'StringBinding', credentialsId: 'b95fe47f-4acd-4a6c-bf06-ffbfbd5ef590',
                      variable: 'AZURE_CRED_JSON']]) {

        /* start with the azure credentials, which look like

        {
          "subscription_id": "XXXXXXXX",
          "client_id": "XXXXXXXX",
          "client_secret": "XXXXXXXX",
          "tenant_id": "XXXXXXXX"
        }
        */

        def vars = parseJson(env.AZURE_CRED_JSON)
        vars["resource_group.name"] = "labisso-tf-nomad-b" + env.BUILD_NUMBER
        vars["storage_account_name"] = "labissotrnsto" + env.BUILD_NUMBER
        vars["build_dns_tag"] = "-labisso-b" + env.BUILD_NUMBER

        vars["resource_group.location"] = "Central US"
        vars["atlas_infrastructure"] = atlasName

        // this is the password used for the launched servers
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '6520da04-9bbd-40eb-9592-2e3c347c0c83',
                          usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
            vars['machine_password'] = env.PASSWORD
        }

        // this is the token for our atlas account
        withCredentials([[$class: 'StringBinding', credentialsId: '1db1672d-846a-4b02-9162-ea5808e35dab',
                          variable: 'ATLAS_TOKEN']]) {
            vars['atlas_token'] = env.ATLAS_TOKEN
        }

        writeFile file: path, text: JsonOutput.prettyPrint(JsonOutput.toJson(vars))
    }
}


def parseJson(json) {
    def jsonSlurper = new JsonSlurper()
    return jsonSlurper.parseText(json)
}