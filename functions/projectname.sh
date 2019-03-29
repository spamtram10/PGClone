#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
projectname () {
pgclonevars

############## REMINDERS
# Make destroying piece quiet and create a manual delete confirmatino
# When user creates project, give them the option to switch
# fix existing set project

############## REMINDERS

# prevents user from moving on unless email is set
if [[ "$pgcloneemail" == "NOT-SET" ]]; then
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '↘️  ERROR! E-Mail is not setup! | Press [ENTER] ' typed < /dev/tty
clonestart; fi

projectcheck="good"
if [[ $(gcloud projects list --account=${pgcloneemail} | grep "pg-") == "" ]]; then
projectcheck="bad"; fi

# prompt user
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Project ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CURRENT PROJECT: $pgcloneproject

[1] Project: Use Existing Project
[2] Project: Build New & Set Project
[3] Project: Destroy
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Value | Press [Enter]: ' typed < /dev/tty

case $typed in
1 )
    if [[ "$projectcheck" == "bad" ]]; then
    echo "BAD"
    clonestart
  elif [[ "$projectcheck" == "good" ]]; then
    exisitingproject; fi ;;
2 )
    projectnameset
    buildproject ;;

3 )
    destroyproject ;;
Z )
    clonestart ;;
z )
    clonestart ;;
* )
    keyinputpublic ;;
esac

}

exisitingproject () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Existing Project ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
projectlist
tee <<-EOF

Qutting? Type >>> Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Use Which Existing Project? | Press [ENTER]: ' typed < /dev/tty
if [[ "$typed" == "Exit" || "$typed" == "exit" || "$typed" == "EXIT" ]]; then clonestart; fi

# Repeats if Users Fails the Range
if [[ "$typed" -ge "1" && "$typed" -le "$pnum" ]]; then
existingnumber=$(cat /var/plexguide/prolist/$typed)

echo
gcloud config set project ${existingnumber} --account=${pgcloneemail}

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Enabling Your API (Standby) ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
gcloud services enable drive.googleapis.com --project ${existingnumber} --account=${pgcloneemail}
else exisitingproject; fi
echo
read -p '↘️  Existing Project Set | Press [ENTER] ' typed < /dev/tty
echo "${existingnumber}" > /var/plexguide/pgclone.project
clonestart
}

destroyproject () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Destroy Project ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
projectlist
tee <<-EOF

Qutting? Type >>> Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Destroy Which Project? | Press [ENTER]: ' typed < /dev/tty
if [[ "$typed" == "Exit" || "$typed" == "exit" || "$typed" == "EXIT" ]]; then optionsmenu; fi

# Repeats if Users Fails the Range
if [[ "$typed" -ge "1" && "$typed" -le "$pnum" ]]; then
destroynumber=$(cat /var/plexguide/prolist/$typed)

  # Cannot Destroy Active Project
  if [[ $(cat /var/plexguide/pgclone.project) == "$destroynumber" ]]; then
  echo
  read -p '↘️  Unable to Destroy an Active Project | Press [ENTER] ' typed < /dev/tty
  destroyproject
  fi

echo
gcloud projects delete ${destroynumber} --account=${pgcloneemail}
else destroyproject; fi
echo
read -p '↘️  Project Deleted | Press [ENTER] ' typed < /dev/tty
optionsmenu
}

projectlist () {
pnum=0
mkdir -p /var/plexguide/prolist
rm -rf /var/plexguide/prolist/* 1>/dev/null 2>&1

gcloud projects list --account=${pgcloneemail} | tail -n +2 | awk '{print $1}' > /var/plexguide/prolist/prolist.sh

while read p; do
  let "pnum++"
  echo "$p" > "/var/plexguide/prolist/$pnum"
  echo "[$pnum] $p" >> /var/plexguide/prolist/final.sh
  echo "[$pnum] ${filler}${p}"
done </var/plexguide/prolist/prolist.sh
}

projectnamecheck () {

pgclonevars
if [[ "$pgcloneproject" == "NOT-SET" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  The PROJECT must be set first!

NOTE: Without setting a project, PG Blitz is unable to establish, build
keys, and deploy the proper GDSA Accounts for the Team Drive

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi

}

projectnameset () {

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - WARNING! PROJECT CREATION! ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING

Creating a NEW PROJECT will require a new Google CLIENT ID and SECRET from
this project to be created! As a result when finished; this will also
result in destroying the set gdrive/tdrive information due to the new
project being created!

This will also destroy any TRANSPORT MODE deployed and including any
mounts. Emby, Plex, and JellyFin Docker containers will also be REMOVED
to prevent any meta-data loss. When set, just redeploy them and will be
good to!

Do You Want to Proceed?
[1] No
[2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Choice | Press [Enter]: ' typed < /dev/tty
case $typed in
1 )
  clonestart ;;
2 )
  a=bc ;;
* )
  optionsmenu ;;
esac

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Project Name ~ pgclone.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Name of your project? Ensure the PROJECT NAME is one word; all lowercase;
no spaces!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Name | Press [Enter]: ' typed < /dev/tty
if [[ "$typed" == "" ]]; then projectnameset; else buildproject; fi
}

buildproject () {
echo ""
date=`date +%m%d`
rand=$(echo $((1 + RANDOM + RANDOM + RANDOM )))
projectid="pg-$typed-${date}${rand}"
gcloud projects create $projectid --account=${pgcloneemail}

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: $projectid ~ Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Enabling the API (Standby)!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

gcloud services enable drive.googleapis.com --project $projectid --account=${pgcloneemail}
echo "$projectid" > /var/plexguide/pgclone.project

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Resetting Prior Stored Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
rm -rf /var/plexguide/pgclone.secret 1>/dev/null 2>&1
rm -rf /var/plexguide/pgclone.public 1>/dev/null 2>&1
rm -rf /var/plexguide/pgclone.secret 1>/dev/null 2>&1
rm -rf /opt/appdata/plexguide/.tdrive 1>/dev/null 2>&1
rm -rf /opt/appdata/plexguide/.gdrive 1>/dev/null 2>&1
rm -rf /opt/appdata/plexguide/.gcrypt 1>/dev/null 2>&1
rm -rf /opt/appdata/plexguide/.tcrypt 1>/dev/null 2>&1
rm -rf /var/plexguide/pgclone.teamdrive 1>/dev/null 2>&1
rm -rf /var/plexguide/deployed.version 1>/dev/null 2>&1

docker stop jellyfin 1>/dev/null 2>&1
docker stop plex 1>/dev/null 2>&1
docker stop emby 1>/dev/null 2>&1
docker rm jellyfin 1>/dev/null 2>&1
docker rm plex 1>/dev/null 2>&1
docker rm emby 1>/dev/null 2>&1

ansible-playbook /opt/pgclone/ymls/remove.yml
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Prior Stored Information is Reset!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: If Plex, Emby, and/or JellyFin was deployed; redeploy them through
PG Box when complete! Ensuring that the containers do not self erase
meta-data due to the mounts being offline!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
}
