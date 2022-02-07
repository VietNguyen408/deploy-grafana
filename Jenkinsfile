pipeline {
    agent any
    tools {
        terraform 'terraform-11'
    }

    stages {
        stage('Setup parameters') {
            steps {
                script {
                    properties([
                        parameters([
                            string(
                                defaultValue: 'deploy-grafana',
                                description: 'This parameter decides the name of terraform workspace',
                                name: 'NAME_TF_WORKSPACE'
                            )                  
                        ])
                    ])
                }
            }
        }

        stage('Get GCP access token') {
            steps {
                script{
                    sh '''cd /opt/ServiceAccount/syndeno
                    ./accesstoken.sh
                    '''
                }
            }
        }

        stage('Git Checkout') {
            steps {
                git credentialsId: 'c94f1316-a4c0-4691-b147-32f390296144', url: 'https://github.com/VietNguyen408/deploy-grafana'
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh '''export TF_VAR_access_token=$(cat /opt/ServiceAccount/syndeno/GCP_ACCESS_TOKEN.txt)
                    terraform init -reconfigure -force-copy -backend-config="access_token=$TF_VAR_access_token" || terraform init -migrate-state -force-copy -backend-config="access_token=$TF_VAR_access_token"
                    terraform workspace select ${NAME_TF_WORKSPACE} || terraform workspace new ${NAME_TF_WORKSPACE} #Will execute second command if first fails
                    terraform workspace show
                    terraform workspace list
                    terraform force-unlock 1644249402768463
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh '''export TF_VAR_access_token=$(cat /opt/ServiceAccount/syndeno/GCP_ACCESS_TOKEN.txt)
                    terraform apply --auto-approve
                    '''
                }
            }
        }
    }
}