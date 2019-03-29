#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
keyinputpublic () {
pgclonevars
if [[ "$pgcloneid" == "ACTIVE" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Change Values? ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CLIENT ID
$pgclonepublic

SECRET ID
$pgclonesecret

WARNING: Changing the values will RESET & DELETE the following:
1. GDrive
2. TDrive
3. Service Keys

Change the Stored Values?
[1] No [2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Value | Press [Enter]: ' typed < /dev/tty
case $typed in
2 )
    rm -rf /opt/appdata/plexguide/.gcrypt 1>/dev/null 2>&1
    rm -rf /opt/appdata/plexguide/.gdrive 1>/dev/null 2>&1
    rm -rf /opt/appdata/plexguide/.tcrypt 1>/dev/null 2>&1
    rm -rf /opt/appdata/plexguide/.tdrive 1>/dev/null 2>&1
    rm -rf /var/plexguide/pgclone.teamdrive 1>/dev/null 2>&1
    rm -rf /var/plexguide/pgclone.public 1>/dev/null 2>&1
    rm -rf /var/plexguide/pgclone.secret 1>/dev/null 2>&1
    ;;
1 )
    clonestart ;;
* )
    keyinputpublic ;;
esac

fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Client ID ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visit oauth.pgblitz.com in order to generate your Client ID! Ensure that
you input the CORRECT Client ID from your current project!

Quitting? Type > exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Client ID | Press [Enter]: ' clientid < /dev/tty
if [ "$clientid" = "" ]; then keyinput; fi
if [ "$clientid" = "exit" ]; then clonestart; fi
keyinputsecret
}

keyinputsecret () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Secret ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visit oauth.pgblitz.com in order to generate your Secret! Ensure that
you input the CORRECT Secret ID from your current project!

Quitting? Type > exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Secret ID | Press [Enter]: ' secretid < /dev/tty
if [ "$secretid" = "" ]; then keyinputsecret; fi
if [ "$secretid" = "exit" ]; then clonestart; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Output ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CLIENT ID
$clientid

SECRET ID
$secretid

Is the following information correct?
[1] Yes
[2] No
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Input Information | Press [Enter]: ' typed < /dev/tty

case $typed in
1 )
    echo "$clientid" > /var/plexguide/pgclone.public
    echo "$secretid" > /var/plexguide/pgclone.secret
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Information Stored | Press [Enter] ' secretid < /dev/tty
    echo "SET" > /var/plexguide/pgclone.id
    ;;
2 )
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Restarting Process | Press [Enter] ' secretid < /dev/tty
    keyinputpublic
    ;;
z )
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Nothing Saved! Exiting! | Press [Enter] ' secretid < /dev/tty
    ;;
Z )
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Nothing Saved! Exiting! | Press [Enter] ' secretid < /dev/tty
    ;;
* )
    clonestart ;;
esac
clonestart
}

publicsecretchecker () {
pgclonevars
if [[ "$pgcloneid" == "NOT-SET" ]]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ oauth.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  Public & Secret Key - NOT SET!

NOTE: Nothing can occur unless the public & secret key are set! Without
setting them; PGBlitz cannot create keys, nor create rclone configurations
to mount the required drives!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi
}
