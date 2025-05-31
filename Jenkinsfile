pipeline {
  agent any

  environment {
    TEAMS_WEBHOOK = credentials('teams-webhook')
  }

  triggers {
    cron('H * * * *')
  }

  stages {
    stage('Checkout Repository') {
      steps {
        checkout scm
      }
    }

    stage('Debug: List Workspace Contents') {
      steps {
        sh '''
echo "=== Workspace Path: $(pwd) ==="
ls -la .
'''
      }
    }

    stage('Install R Dependencies') {
      steps {
        sh '''
Rscript -e "if (!requireNamespace('binancer', quietly = TRUE)) install.packages('binancer', repos='https://cloud.r-project.org')"
'''
      }
    }

    stage('Run ETH Min/Max Script') {
      steps {
        sh 'Rscript eth_min_max.R'
      }
    }
  }

  post {
    failure {
      emailext (
        subject: "Jenkins ❌ Job '${env.JOB_NAME}' build #${env.BUILD_NUMBER} Failed",
        body: """
Hello,

The Jenkins job *${env.JOB_NAME}* (build #${env.BUILD_NUMBER}) has failed.

Check the console output here:
${env.BUILD_URL}console

— Jenkins
""",
        recipientProviders: [[$class: 'DevelopersRecipientProvider']]
      )
    }
  }
}
