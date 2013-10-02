# Do not change this path
PATH=/bin:/usr/bin:/sbin:/usr/sbin
# The path to the EdenManager server.
DIR=/opt/EdenManager
DAEMON=EdenManager.rb
# PID of the running manager 
PID=$(ps aux | grep EdenManager | grep -v grep | awk '{print $2}')
# Change all PARAMS to your needs.
PARAMS=""
DESC="EdenManager"
case "$1" in
  start)
    echo "Starting $DESC , please wait"
    ruby -X $DIR $DAEMON
    ;;
  stop)
    if [ ! -z "$PID" ]
    then
      kill -9 $PID
      echo " ... done. $DESC (PID:$PID) Stopped."
    else
      echo "$DESC is not running"
    fi
    ;;
  restart)
    if [ ! -z "$PID" ]
    then
      kill $PID
    fi
    ruby -X $DIR $DAEMON
    echo " ... done. $DESC Restarted"
    ;;
  status)
    # Check whether there's a "EdenManager" process
    ps aux | grep -v grep | grep EdenManager > /dev/null
    CHECK=$?
    [ $CHECK -eq 0 ] && echo "$DESC is UP" || echo "$DESC is DOWN"
    ;;
  *)
    echo "Usage: $0 {start|stop|status|restart}"
    exit 1
    ;;
esac
exit 0

