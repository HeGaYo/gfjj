#!/bin/bash
JDK_DIR="/usr/local/java"
JDK_FILE="jdk-6u45-linux-x64.bin"
CONFIG_FILE="/etc/profile"
if [ -d $JDK_DIR ];then
	rm -rf $JDK_DIR
fi
mkdir $JDK_DIR
cd $JDK_DIR
sudo cp /oa/$JDK_FILE  .
sudo chmod 777 $JDK_FILE
sudo ./$JDK_FILE
JAVA_HOME="$JDK_DIR/jdk1.6.0_45"
sed -i '/java/d'  $CONFIG_FILE
sed -i '/jre/d' $CONFIG_FILE
sed -i '/lib/d' $CONFIG_FILE
sed -i '/bin:$PATH/d' $CONFIG_FILE
echo "export JAVA_HOME=${JAVA_HOME}" >>$CONFIG_FILE
echo 'export JRE_HOME=${JRE_HOME}/jre' >>$CONFIG_FILE
echo 'export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' >>$CONFIG_FILE
echo 'export PATH=${JAVA_HOME}/bin:$PATH' >> $CONFIG_FILE
source /etc/profile
java -version
sudo update-alternatives --install /usr/bin/java java /usr/local/java/jdk1.6.0_45/bin/java 300  
sudo update-alternatives --install /usr/bin/javac javac /usr/local/java/jdk1.6.0_45/bin/javac 300


