#!/bin/bash

#turn on ssh
systemsetup -setremotelogin on

#allow all users to login
/usr/bin/dscl . -delete /Groups/com.apple.access_ssh

# set the input for lazy convenience
IFS=$' '
 
localadmins=$(/usr/bin/dscl localhost -read /Local/Default/Groups/admin GroupMembership | awk -F': ' '{print $2}')
 
for account in `echo $localadmins`; do
# add additional blocks like >> && ! [ "$account" == "username" ] << for additional exclusions
if ! [ "$account" == "root" ] && ! [ "$account" == "itstech" ]; then
userID=$(/usr/bin/dscl localhost -read /Local/Default/Users/$account | grep GeneratedUID | awk '{print $2}')
if [ "$userID" != "" ]; then
# We first need to test if the access_ssh group exists and create it if it doesn't
/usr/bin/dscl localhost -read /Local/Default/Groups/com.apple.access_ssh > /dev/null 2>&1
rc=$?
if [[ $rc != 0 ]]; then
/usr/bin/dscl localhost -create /Local/Default/Groups/com.apple.access_ssh
/usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh RealName 'Remote Login Group'
/usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh PrimaryGroupID 104
fi
/usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh GroupMembership "$admin"
/usr/bin/dscl localhost -append /Local/Default/Groups/com.apple.access_ssh GroupMembers "$userID"
else
echo "$account has no local GUID"
fi
fi
done