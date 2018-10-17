node {
    checkChange()
    try {
        stage('Stage Checkout') {
            checkout scm
            echo "My branch is: ${env.BRANCH_NAME}"
        }
        stage('Stage Build') {
		    sh "echo ${env.BRANCH_NAME} >branch.txt"
		    sh "chmod 755 changelist.sh && bash ./changelist.sh"
//          sh "mvn clean deploy -Dmaven.test.skip=true -U -f pom.xml"
	        print currentBuild.result
			if (currentBuild.result == null || currentBuild.result == 'SUCCESS') { 
            sh "echo ''>../bt-business/${env.BRANCH_NAME}_pre.txt"
        }
        }
        stage('Stage Builddiscard') {
            properties([disableConcurrentBuilds(),[$class: 'GitLabConnectionProperty', gitLabConnection: 'gitlab'], [$class: 'JobRestrictionProperty'], buildDiscarder(logRotator(daysToKeepStr: '3', numToKeepStr: '3'))])
        }
    }
    catch (err) {
        currentBuild.result = "FAILED"
        sh "sed -i 's!env.BUILD_URL!${env.BUILD_URL}!g' dingding.json"
        sh "sed -i 's!env.JOB_NAME!${env.JOB_NAME}!g' dingding.json"
        sh "curl -X POST https://oapi.dingtalk.com/robot/send?access_token=ae3b70e881246f10b2302a471209b258cfc3dc3faa57bef05215f8ad9c226a70 -d @dingding.json -H 'Content-type:application/json'"
        sh "cat changelog.txt >../bt-business/${env.BRANCH_NAME}_pre.txt"
		notifyFailed(err)
        throw err
    }

}
@NonCPS
def void checkChange() {
    def changeLogSets = currentBuild.rawBuild.changeSets
    def flag = false
    def strChange = "以下配置文件发生了变化:\n"
	def modiyfile = " "
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
//            echo "${entry.commitId} by ${entry.author} on ${new Date(entry.timestamp)}: ${entry.msg}"
            def files = new ArrayList(entry.affectedFiles)
            for (int k = 0; k < files.size(); k++) {
                def file = files[k]
                if (file.path.contains('src/main/resources')) {
                    flag = true
                    strChange += "${file.editType.name} ${file.path}\n"
                }
				modiyfile += "${file.path}"	
			    modiyfile += ":"
            }
        }
    }
	getmodiyfile(modiyfile)
    if (flag == true) {
        notifySCMChanged(strChange)
    }
	
}

def getmodiyfile(def files) {
   
    sh "echo '修改文件列表'"
    sh "echo ${files}"
	sh "echo ${files}>changefile.txt"

	
	}
	
def notifySCMChanged(def files) {
    emailext(
            subject: "配置文件变化: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}] [${env.BRANCH_NAME}]'",
            body: """${files}
查看文件变化: ${env.BUILD_URL}changes
""",
//            recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']],
            to: 'scm@cheok.com,cld@cheok.com'
    )
}

def notifyFailed(def err) {
    emailext(
            subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}] [${env.BRANCH_NAME}]'",
            body: """FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}] [${env.BRANCH_NAME}]':
Check console output at ${env.BUILD_URL}
ERROR:
${err}
""",
            recipientProviders: [[$class: 'CulpritsRecipientProvider'], [$class: 'RequesterRecipientProvider']],
            to: 'scm@cheok.com'
    )
}

