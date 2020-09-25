#!/bin/bash

switch_version()
{
    echo "Switching to PHP"$version
    apt install php$version-dev
    a2dismod php*
    a2enmod php$version
    service apache2 restart

    update-alternatives --set php /usr/bin/php$version
    update-alternatives --set phar /usr/bin/phar$version
    update-alternatives --set phar.phar /usr/bin/phar.phar$version
    update-alternatives --set phpize /usr/bin/phpize$version
    update-alternatives --set php-config /usr/bin/php-config$version
}

install_version()
{
    # while true; do
        read -p "PHP$version is not installed `echo '\n '`Would like to install this PHP$version [Y/n] ?" answer
        answer=${answer:-yes}
        case $answer in
            [Yy]* ) add-apt-repository ppa:ondrej/php; apt update; apt install php$version; apt install php$version-dev break;;
            [Nn]* ) exit;;
            * ) echo "In Valid Entry. Abort"; exit;;
        esac
    # done
}

read -p "Please enter the version to switch (Ex. 5.6): `echo '\n> '`" version

dpkg -s php$version 2> /dev/null

if [ $? -eq 0 ]; then
    switch_version
else
    install_version
    switch_version
fi
