#!/bin/bash

# Based on https://help.ubnt.com/hc/en-us/articles/205223340-EdgeRouter-Ad-blocking-content-filtering-using-EdgeRouter

ad_list_url="http://pgl.yoyo.org/adservers/serverlist.php?hostformat=dnsmasq&showintro=0&mimetype=plaintext"
# The IP address below should point to the IP of your router or to 0.0.0.0
pixelserv_ip="0.0.0.0"
ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf"
temp_ad_file="/etc/dnsmasq.d/dnsmasq.adlist.conf.tmp"

curl -s $ad_list_url | sed "s/127\.0\.0\.1/$pixelserv_ip/" > $temp_ad_file

# Add some other czech ads that are not listed
echo "address=/c.imedia.cz/$pixelserv_ip" >> $temp_ad_file
echo "address=/h.imedia.cz/$pixelserv_ip" >> $temp_ad_file
echo "address=/i.imedia.cz/$pixelserv_ip" >> $temp_ad_file
echo "address=/gacz.hit.gemius.pl/$pixelserv_ip" >> $temp_ad_file
echo "address=/ls.hit.gemius.pl/$pixelserv_ip" >> $temp_ad_file

if [ -f "$temp_ad_file" ]
then
        sed -i -e '/googleadservices\.com/d' $temp_ad_file
        mv $temp_ad_file $ad_file
else
        echo "Error building the ad list, please try again."
        exit
fi

/etc/init.d/dnsmasq force-reload

clear dns forwarding cache
