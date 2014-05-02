#!/bin/sh
sleep 3
/etc/init.d/quagga start
/opt/rfclient/rfclient > /var/log/rfclient.log
