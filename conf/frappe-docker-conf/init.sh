#!/bin/bash -x

# turn on debug mode
set -x

# env has been set from dockerfile
benchWD=/home/$systemUser/$benchName

cd $benchWD

echo "----------------------- [ remove old site ] ---------------------------------"
cd sites
rm -rf $siteName
cd ..

echo "----------------------- [ config bench ] ---------------------------------"
cp ~/frappe-docker-conf/common_site_config_docker.json $benchWD/sites/common_site_config.json
bench set-mariadb-host mariadb

echo "----------------------- [ create new site ] ---------------------------------"
bench new-site $benchNewSiteName
bench use $benchNewSiteName

echo "----------------------- [ create install erpnext ] ---------------------------------"
bench install-app erpnext

echo "----------------------- [ fixed JS error ] ---------------------------------"
bench update --build

echo "----------------------- [ start supervisor ] ---------------------------------"
sudo /usr/bin/supervisord

# turn off debug mode
set +x

echo "-"
echo "-"
echo "-"
echo "----------------------- [ DONE! ] ---------------------------------"