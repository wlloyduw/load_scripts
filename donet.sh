# This network load generation script requires an endpoint (server)
# where data will be transfered to...
#
# The transfer rate will need to be set relative to the size of
# the network pipe
#
# The files sftpbatchput and sftpbatchget must exist in the same directory
# as the script.  Also, they must refer to a valid file for transferring
#
# Ideally the transfer file for sftpbatchput/get will be a large file
#
# The script will repeatedly transfer the file...
#
dest=52.44.186.120
user=ubuntu
sshkey=/home/wlloyd/Dropbox/aws/uw/uw_wlloyd_1.pem
#scp -i $sshkey somedata $user@$dest:/dev/null
transferrate=0
# throughput: 1 = max net, 2 = 25% net, 3 = 2% net
# direction: 1 = up to erams2, 2 down from erams2
if [ $# -eq 0 ]
then
  echo "Usage: donet [transfer rate] [direction] "
  echo ""
  echo "transfer rate:   1- saturation, max transfer rate of sftp"
  echo "                 2- Approx. 25% of max transfer rate of sftp"
  echo "                 3- Approx. 2% of max transfer rate of sftp"
  echo ""
  echo "direction:       1- Send to $user@$dest (nbs)"
  echo "direction:       2- Receive from $user@$dest (nbr)"
  exit
fi
throughput=$1
direction=$2
case $throughput in
1 ) echo "max net"; transferrate=1400000;;
2 ) echo "25% net"; transferrate=120000;;
3 ) echo "2% net"; transferrate=12000;;
esac 
echo $sleeptime
failure=""
file=/var/log/auth.log.1
localfile=localcopy
i=0
while [ -z "$failure" ]
do
   if [ $direction -eq 1 ]
   then
     sftp -i $sshkey -q -b sftpbatchput -l $transferrate $user@$dest
   fi

   if [ $direction -eq 2 ]
   then
     sftp -i $sshkey -q -b sftpbatchget -l $transferrate $user@$dest
   fi
done

