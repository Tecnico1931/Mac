#!/bin/sh
# Remove MCX prefs from a profile/machine
dscl . -list Computers | grep -v "^localhost$" | while read computer_name ; do sudo dscl . -delete Computers/"$computer_name" ; done
user=`ls -la /dev/console | cut -d " " -f 4`
dscl . -delete /Users/$user MCXSettings
dscl . -delete /Users/$user MCXFlags
dscl . -delete /Users/$user cached_groups
dscl . -delete /Users/$user dsAttrTypeStandard:MCXSettings
rm -fr /private/var/db/dslocal/nodes/Default/computers/localhost.plist

#remove Jamf Framework
/usr/sbin/jamf removeFramework

#remove selfservice
rm -rf "/Applications/Self\ Service.app"
rm /Users/$user/Library/Preferences/com.jamfsoftware.*