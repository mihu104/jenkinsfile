pipeline{
agent {any} 
stages {
stage('Deploy') {
 steps {
			  script {
  input "Deploy?"
   }
  milestone()
  lock('Deployment') {
    node (any){
      echo "Deploying"
    }
  }
 
  
  }
}
}

}