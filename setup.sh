#!/bin/bash

current_directory=${PWD##*/}

col=5

RED='\e[0;31m'
GREEN='\e[0;32m'
NC='\e[0m'
BLINK='\e[5m'

function print_failed()
{
	printf '\t\t\t%b\n' "[ ${RED}${BLINK}FAILED ${NC}]"
}

function print_ok()
{
	printf '\t\t\t\t%b\n' "[ ${GREEN}OK ${NC}]"
}

echo "Hello there!"
echo "This installer is created to install Laravel easy with the help of Docker and Git!"
echo
#echo -n "Checking if you run this installer as root."
#if [ "$(whoami)" != "root" ]; then
#	print_failed
#	echo
#	echo
#	echo "It appears that you are not running this installer as root!"
#	echo "Please make sure that you are running it as root!"
#	exit 1
#else
#	print_ok
#fi

echo -n "Checking if you have Git installed on your system."
if [ ! -x "$(command -v git)" ]; then
	print_failed
	echo

	echo "Would you like to install Git?"
	select yn in "Yes" "No"; do
	case $yn in
		Yes )
			echo
			echo
			sudo apt-get update && sudo apt-get install git
		break;;
		No )
			echo "Cancel";
			exit;;
	esac
	done
else
	print_ok
fi

echo -n "Checking if you have docker installed on your system."
if [ ! -x "$(command -v docker)" ]; then
	print_failed
else
	print_ok
fi

echo
echo "Next, I will ask what the directory should be named. Make sure that this directory is not exists and it's empty!"
read -p "Enter your project name [laravel-app]: " project_name
project_name=${project_name:-laravel-app}

echo
echo "Going to the upper directory."
cd ..
echo "Current working directory: ${PWD}"
echo "Creating \"$project_name\" folder in ${PWD}."
mkdir $project_name
echo
echo

git clone https://github.com/laravel/laravel.git ./$project_name

cp -r "$current_directory/.docker/" "$project_name/"
cp "$current_directory/docker-compose.yml" "$project_name/"
cp "$project_name/.env.example" "$project_name/.env"

cd $project_name

docker build --file .docker/Dockerfile -t laravel-docker .
docker container create --name $project_name laravel-docker
docker container cp $project_name:/var/www/laravel-app/vendor $PWD
docker container rm -f $project_name

php artisan key:generate
