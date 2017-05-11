if [ $# -eq 0 ]
then
  echo "Usage: docpu [load]"
  echo ""
  echo "load:    1- Near 100% CPU load"
  echo "load:    2- Near 25% CPU load"
  echo "load:    3- Near 2% CPU load"
  exit
fi
load=$1
# load 1 = 100%, load 2 = 25%, load 3 = 2%
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
