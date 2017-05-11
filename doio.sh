# This script creates a disk load
# It constantly reads or writes the somedata file which is approx 770k
# 
failure=""
file=somedata
localfile=localcopy
useris=`whoami`
if [ "$useris" != "root" ]
then
  echo "Must be run as root for cache clearing!"
  exit
fi
if [ $# -eq 0 ]
then
  echo "Usage: doio [rate] [type]"
  echo ""
  echo "rate:    1- saturation, transfers 770k file with .002 sec sleep interval"
  echo "rate:    1- Approx 20%, transfers 770k file with .2 sec sleep interval"
  echo "rate:    1- Approx 2%, transfers 770k file with 2 sec sleep interval"
  echo ""
  echo "type:    1- Disk write only (dsw) - No internal cache clearing"
  echo "type:    2- Disk read and write (dsr/dsw) - Caches cleared"
  echo "type:    3- Disk read only (dsr) - Writes to /dev/null"
  exit
fi
load=$1
type=$2
case $load in
1 ) echo "i/o saturation"; sleeptime=.002;;
2 ) echo "20% io"; sleeptime=.2;;
3 ) echo "2% io"; sleeptime=2;;
esac
if [ $type -eq 3 ]
then
  localfile=/dev/null
fi
i=0
while [ -z "$failure" ]
do
  cp $file $localfile
  if [ $type -eq 2 ]
  then
    echo 3 > /proc/sys/vm/drop_caches
  fi
  sleep $sleeptime
done
