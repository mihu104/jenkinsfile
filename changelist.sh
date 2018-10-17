sed -i "s/:/\n/g" changefile.txt
echo "本次修改工程列表"
BRANCH_NAME=`cat branch.txt`
echo $BRANCH_NAME
cat changefile.txt
cat changefile.txt | awk  -F "/" '{print $1}' >changelog.txt
cat ../bt-business/${BRANCH_NAME}_pre.txt >>changelog.txt
cat changelog.txt | sort -u | uniq | sort -r >changelist.txt
cp pom.xml pom_jenkins.xml
sed -i "s/<module>/<\!\-\-<module>/g" pom_jenkins.xml
sed -i "s/<\/module>/<\/module>\-\->/g" pom_jenkins.xml
ver=`mvn -q -N -Dexec.executable='echo'  -Dexec.args='${project.version}'  org.codehaus.mojo:exec-maven-plugin:1.3.1:exec`
sed -i "s/${ver}/1.0-SNAPSHOT/" pom_jenkins.xml


for i in `cat changelist.txt`; do sed -i "s/<\!\-\-<module>${i}<\/module>\-\->/<module>${i}<\/module>/g" pom_jenkins.xml; done

for i in `cat changelist.txt` ;
do
if [ $i == "pom.xml" ]; then
 mvn clean deploy -Dmaven.test.skip=true -U -f pom.xml
 if [ $? != "0" ]; then
exit 1
else
echo "全部编译"
break
fi

elif [[ $i =~ "business" ]]; then
mvn clean deploy -Dmaven.test.skip=true -U -f pom_jenkins.xml
if [ $? != "0" ]; then
exit 1
else
echo "增量编译"
break
fi

else
echo "没有修改源代码"
fi
done


