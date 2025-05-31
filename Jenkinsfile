pipeline {
  agent any

  // Import the Teams webhook URL from Jenkins Global Credentials (ID: "teams-webhook")
  environment {
    TEAMS_WEBHOOK = credentials('teams-webhook')
  }

  // Schedule: run once every hour at a hashed minute (e.g., "H * * * *")
  triggers {
    cron('H * * * *')
  }

  stages {
    stage('Checkout Repository') {
      steps {
        // Ensure the Git repo (containing Jenkinsfile and eth_minmax.R) is cloned into the workspace
        checkout scm
      }
    }

    stage('Debug: List Workspace Contents') {
      steps {
        // List all files/folders at workspace root to confirm eth_minmax.R is present
        sh '''
echo "=== Workspace Path: $(pwd) ==="
ls -la .
'''
      }
    }

    stage('Install R Dependencies') {
      steps {
        // Install the 'binancer' package if it’s not already installed
        sh '''
Rscript -e "if (!requireNamespace('binancer', quietly = TRUE)) install.packages('binancer', repos='https://cloud.r-project.org')"
'''
      }
    }

    stage('Run ETH Min/Max Script') {
      steps {
        // Run the R script. Make sure the filename matches exactly what’s in your Git repo.
        sh 'Rscript eth_minmax.R'
      }
    }
  }

  post {
    failure {
      // If any stage fails, send an email notification to configured developers
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
