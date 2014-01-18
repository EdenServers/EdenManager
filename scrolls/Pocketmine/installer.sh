#!/bin/bash
PMMP_VERSION="Alpha_1.3.11"
update=off

while getopts "ud" opt; do
  case $opt in
    u)
	  update=on
      ;;
	d)
	  PMMP_VERSION="master"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
	  exit 1
      ;;
  esac
done

echo "[INFO] PocketMine-MP $PMMP_VERSION downloader & installer for Linux & Mac"
echo "[0/2] Cleaning..."
rm -r -f src/
rm -f PocketMine-MP.php
rm -f README.md
rm -f CONTRIBUTING.md
rm -f LICENSE
rm -f start.sh
rm -f start.bat
echo "[1/2] Downloading PocketMine-MP $PMMP_VERSION..."
set -e
wget https://github.com/shoghicp/PocketMine-MP/archive/$PMMP_VERSION.tar.gz --no-check-certificate -q -O - | tar -zx > /dev/null
mv -f PocketMine-MP-$PMMP_VERSION/* ./
rm -f -r PocketMine-MP-$PMMP_VERSION/
rm -f ./start.cmd
chmod 0755 ./start.sh
chmod 0755 ./src/build/compile.sh
if [ $update == on ]; then
	echo "[2/2] Skipping PHP recompilation due to user request"
else
	echo "[2/2] Compiling PHP"
	if [ `getconf LONG_BIT` = "64" ]
	then
		echo "[2/2] Compiling PHP using 64-bit"
		CFLAGS="-m64" ./src/build/compile.sh
        else
		echo "[2/2] Compiling PHP using 32-bit"
        	./src/build/compile.sh
	fi
fi
echo "[INFO] Done"
