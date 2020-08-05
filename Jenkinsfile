pipeline {
  agent any
  stages {
    stage('Staging Deploy') {
      steps {
        when() {
          branch '*/*'
        }

        steps() {
          withAWS(region: 'us-east-1', credentials: '450441e5-7cf1-49bf-b82f-62294886fcd9') {
            s3Delete(bucket: 'staging.treysimmons.io', path: '**/*')
            s3Upload(bucket: 'staging.treysimmons.io', file: '/')
          }

          mail(subject: 'Staging Build - treysimmons.io', body: 'New Deployment to Staging', to: 'donaldpsimmons3@gmail.com')
        }

      }
    }

  }
}