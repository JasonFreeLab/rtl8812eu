#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must run this with superuser priviliges.  Try \"sudo ./dkms-install.sh\"" 2>&1
  exit 1
else
  echo "About to run dkms install steps..."
fi

DRV_DIR=rtl88x2eu
DRV_NAME=rtl88x2eu
DRV_VERSION=5.15.0.1

cp -r $(pwd) /usr/src/${DRV_NAME}-${DRV_VERSION}

dkms add -m ${DRV_NAME} -v ${DRV_VERSION}
dkms build -m ${DRV_NAME} -v ${DRV_VERSION}
dkms install -m ${DRV_NAME} -v ${DRV_VERSION}
RESULT=$?

echo "Finished running dkms install steps."


	if echo "net.ipv6.conf.all.disable_ipv6 = 1
  net.ipv6.conf.default.disable_ipv6 = 1
  net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf; then
		echo "Disabled IPv6 Successfuly "
		sysctl -p
	else
		echo "Could not disable IPv6"
	fi



exit $RESULT
