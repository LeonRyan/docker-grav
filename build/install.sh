#!/bin/bash

GRAV_VERSION=0.9.45

cd /setup

# remove existing chaperone.d and startup.d from /apps so none linger
rm -rf /apps; mkdir /apps

# copy everything from setup to the root /apps except Dockerfile rebuild materials
echo copying application files to /apps ...
tar cf - --exclude ./build \
         --exclude ./build.sh \
    	 --exclude ./www/grav \
         --exclude ./run.sh . | (cd /apps; tar xf -)

# update the version information
mv /setup/build/new_version.inc /apps/etc/version.inc

# PHP EXTENSIONS!
#
# Add any php extensions your application needs.  Alpine Linux is VERY granular and
# does not contain the large number of extensions you'd expect in a Ubuntu/Debian/CentOS
# install.  You can find the package names here...
# https://pkgs.alpinelinux.org/packages?name=php-%25&repo=all&arch=x86_64&maintainer=all

apk --update add \
    php-json \
    php-ctype \
    php-gd \
    php-curl \
    php-openssl \
    php-zip

mkdir -p /setup/grav; cd /setup/grav
wget https://github.com/getgrav/grav/releases/download/$GRAV_VERSION/grav-admin-v$GRAV_VERSION.zip
cd /apps/www
unzip /setup/grav/grav-admin-v$GRAV_VERSION.zip
mv grav-admin grav

cp /setup/build/garyw.yaml /apps/www/grav/user/accounts

# Add additional setup commands for your production image here, if any.
# ...

# Clean up and assure permissions are correct

rm -rf /setup
chown -R runapps: /apps    # for full-container execution
