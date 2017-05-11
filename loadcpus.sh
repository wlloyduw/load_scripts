# generates a multi-core CPU load
# at the specified level of activity
# extremely lo-fi busy waiting
#
# 1 - is 100% cpu load
# 2 - is ~17-20% cpu load
# 3 - ~2%, sleep value will need adjusting based on system capabilities
docpu()
{
  load=$1
  failure=""
  i=1
  j="true"
  while [ -z "$failure" ];
  do
    if [ $load -eq 1 ]
    then
      if [[ $failure ]]
      then
        break
      fi
    fi
    if [ $load -eq 2 ]
    then
      i=`expr $i + 1`
      if [ "$j" == "true" ]
      then
        i=`echo $i + 1 | bc -l`
        j="false"
      else
        i=`echo $i - 1 | bc -l`
        j="true"
      fi
    fi
    if [ $load -eq 3 ]
    then
      sleep .025
    fi
  done
}

if [ $# -eq 0 ]
then
  echo "Usage: loadcpu [cores] [load]"
  echo ""
  echo "cores:   # of CPU cores to occupy"
  echo ""
  echo "load:    1- Near 100% CPU load"
  echo "load:    2- Near 25% CPU load"
  echo "load:    3- Near 2% CPU load"
  exit
fi
cores=$1
load=$2
if [ $load -eq 1 ]
then
  cores=`expr $cores + $cores`
  load=2
fi
# load 1 = 100%, load 2 = 25%, load 3 = 2%
for (( i=0 ; i < $cores; i++ ))
do
  #./docpu.sh $load &
  docpu $load &
done

