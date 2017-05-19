#!/bin/bash

#parament:C11,Y2
git checkout .
git clean -fd

 git pull origin POC_G6_only 

echo "parament:$1  num:$#"
function replace()
{
  projecttype=`pwd`/PTTTalk/src/main/java/com/android/zello/ProjectType.java
  sed "s/projectType[ ]*=[ ]*[a-z]*[A-Z]*[0-9]*[_][a-z]*[A-Z]*[0-9]*;/projectType = PROJECT_$project;/g" $projecttype >temp
  mv temp $projecttype
  return 1
}

if [ $# -ne 1 ] 
then
    echo "选择编译工程：C11,Y2"
    read project
else 
     project=$1
fi

echo "project:$project"
if [ "$project" = "C11" ]
then
    mv ./PTTTalk/build_g6.gradle  ./PTTTalk/build.gradle
    replace
elif [ "$project" = "Y2" ]
then
    mv ./PTTTalk/build_g7.gradle  ./PTTTalk/build.gradle
    replace
else
    echo "error parament"
fi

rm -r ./androidngnstack/src/main/java/com
#build

./gradlew clean
./gradlew assembleRelease

signed_apk=`pwd`/PTTTalk-release-signed.apk

unsigned_apk=`pwd`/PTTTalk/build/outputs/apk/PTTTalk-release-unsigned.apk

cmd="jarsigner -verbose -keystore PTTTalk/src/main/key/key -storepass 111111 -keypass 111111 -signedjar $signed_apk $unsigned_apk cmccsso -digestalg SHA1 -sigalg MD5withRSA"

eval $cmd

mainfestPath=`pwd`/PTTTalk/src/main/AndroidManifest.xml
name=`grep "android:versionName=" $mainfestPath`

version=`echo $name | grep -Eo 'POC[a-zA-Z0-9_.]*'`
echo "version = $version"

mkdir $version
cp -r $signed_apk ./$version/${version}.apk
cp -r `pwd`/PTTTalk/build/outputs/mapping/release/mapping.txt  ./$version

cp $version ~/shared/

git tag version
git push origin --tags POC_G6_only


