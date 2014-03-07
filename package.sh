######################
# Tweak these values #
######################
API_VERSION=19
REVISION=3
######################

MANIFEST_CONTENT="# SDK Add-on Manifest
# File encoding is UTF-8

# Name and vendor of the add-on.
# Add-ons are uniquely identified by a string composed of name, vendor and api.
# 2 add-ons with the same identifier cannot be installed in the same SDK
# and only the add-on with the highest rev number will be installed.
# Name and vendor are used to create folder names, so they shouldn't contain
# any special characters. Also, the character ':' is forbidden.
# Mandatory character set: a-z A-Z 0-9 _.-
name=Cyanogenmod Api
vendor=Cyanogenmod
description=Cyanogenmod API

# version of the Android platform on which this add-on is built.
api=$API_VERSION

# revision of the add-on. This must be a strict integer.
revision=$REVISION

# list of libraries, separated by a semi-colon.
# This must be the name of the libraries, as required by the
# <uses-library> node in the AndroidManifest.xml file.
libraries=org.cyanogenmod.support

# details for each library. format is:
# <library.name>=<name>.jar;<desc>
# where
# <library.name>: the name of the library defined in the property \"libraries\" above.
# <name>.jar: the jar file containing the library API. This is to be located in
#             the add-on folder in libs/
org.cyanogenmod.support=cmapi.jar;Cyanogenmod Api's"

ZIP="CmApi.zip"

# Validate if the file input is a jar
file_ext=${1##*.}
if [ "$file_ext" != "jar" ];
then
    echo "Not a jar !"
    exit
fi

mkdir CMAPI
cd CMAPI

# Copy the jar into the libs directory
mkdir libs
cp $1 libs/cmapi.jar

# Create the manifest
echo "$MANIFEST_CONTENT" > manifest.ini

# Zip up the entire folder
cd ..
zip -r $ZIP CMAPI
rm -rf CMAPI

SHASUM=`sha1sum $ZIP | cut -f1 -d" "`
SIZE=`stat -c %s $ZIP`

REPOSITORY_CONTENT="<sdk:sdk-addon xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:sdk=\"http://schemas.android.com/sdk/android/addon/4\">
	<sdk:add-on>
		<sdk:name-id>CMAPI</sdk:name-id>
		<sdk:name-display>Cyanogenmod API's</sdk:name-display>
		<sdk:api-level>$API_VERSION</sdk:api-level>
		<sdk:vendor-id>CM</sdk:vendor-id>
		<sdk:vendor-display>Cyanogenmod</sdk:vendor-display>
		<sdk:revision>$REVISION</sdk:revision>
		<sdk:description>Cyanogenmod specific API's. Only for devices running cyanogenmod.</sdk:description>
		<sdk:desc-url>http://wiki.cyanogenmod.org/w/Development</sdk:desc-url>
		<sdk:uses-license ref=\"cmlicense\"/>
		<sdk:archives>
			<sdk:archive os=\"any\">
				<sdk:size>$SIZE</sdk:size>
				<sdk:checksum type=\"sha1\">$SHASUM</sdk:checksum>
				<sdk:url>https://github.com/Danesh/cm_api/blob/master/CmApi.zip?raw=true</sdk:url>
			</sdk:archive>
		</sdk:archives>
		<sdk:libs></sdk:libs>
	</sdk:add-on>
	<sdk:license type=\"text\" id=\"cmlicense\">LICENSE</sdk:license>
</sdk:sdk-addon>"

echo "$REPOSITORY_CONTENT" > repository.xml

