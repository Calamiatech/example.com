#!/bin/bash
if [ -z "$1" ]; then
	echo usage: $0 directory
	exit
fi

PN=$1
WP="/opt/bitnami/apps/wordpress/"
MNT=$WP$PN

# Mount the Shared Project Folder
mkdir $MNT
mount .host:/$PN $MNT
# sudo cp /home/bitnami/fstab /etc/fstab
  
# Point Apache at the proper directory and set domain name
OLD="example.com"
NEW=$1
DPATH="/opt/bitnami/apps/wordpress/conf/httpd-*.conf"
BPATH="/home/bitnami/"
TFILE="/tmp/out.tmp.$$"
[ ! -d $BPATH ] && mkdir -p $BPATH || :
for f in $DPATH
do
  if [ -f $f -a -r $f ]; then
    /bin/cp -f $f $BPATH
   sed "s/$OLD/$NEW/g" "$f" > $TFILE && mv $TFILE "$f"
  else
   echo "Error: Cannot read $f"
  fi
done
/bin/rm $TFILE
