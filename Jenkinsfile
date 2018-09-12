pipeline{
agent {label 'maven-slave'} 
stages {
stage('Deploy') {
 steps {
			  script {
  input "Deploy?"
  }
  }
  milestone()
  lock('Deployment') {
    node ('maven_slave'){
      echo "Deploying"
    }
  }
}
}

}