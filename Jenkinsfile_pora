pipeline {
    agent none
    stages {
	    stage('checkout') {
		 agent {label 'maven-slave'}
		steps {
        echo "1.下载代码"
        dir('code') {
          git credentialsId: 'e45eb393-dabb-47c2-bd3b-1f31ec60847c', url: 'git@github.com:mihu104/eureka-server.git'
                    }
		  }
		  }
        stage('Build') {
		agent {
        docker {
            image 'huxiaofeng/maven:1.2'
            args '-v /var/run/docker.sock:/var/run/docker.sock -v /home/jenkins:/home/jenkins -v /home/jenkins/.dockercfg:/home/jenkins/.dockercfg'
        }
    }
            steps {
				sh "cd code && mvn package docker:build -Dmaven.test.skip=true"
				script {
				prover=sh(returnStdout: true, script: "mvn -q -N -Dexec.executable='echo'  -Dexec.args='\${project.version}'  org.codehaus.mojo:exec-maven-plugin:1.3.1:exec").trim()
      		    proname=sh(returnStdout: true, script: "mvn -q -N -Dexec.executable='echo'  -Dexec.args='\${project.artifactId}'  org.codehaus.mojo:exec-maven-plugin:1.3.1:exec").trim()

	             }
                sh "docker push huxiaofeng/${proname}:${prover}"
				
            }
        }
		stage('deploy') {
	   agent {label 'deploy-slave'}
	
            steps {
				sh "docker pull huxiaofeng/${proname}:${prover}"
				sh "docker run -d huxiaofeng/${proname}:${prover}"
				
            }
        
		}
		
    }
	
}