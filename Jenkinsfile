pipeline{
agent {label 'maven-slave'} {
stage('Deploy') {
  input "Deploy?"
  milestone()
  lock('Deployment') {
    node ('maven_slave'){
      echo "Deploying"
    }
  }
}
}
}