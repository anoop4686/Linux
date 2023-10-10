#!/usr/bin/sh

echo  "Do you want to continue with current $USER username : " 
read input

if [ $input == yes ]
then
    echo "script run from here"
else
    echo "Enter another user : "
    read user
    sudo su - $user
fi 

