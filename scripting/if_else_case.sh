#! /usr/bin/bash

echo "Enter your name : "

read name

if [ $name == "Anoop" ]
then
    echo "Welcome Anoop"
elif [ $name == "Suraj" ]
then
    echo "Welcome Suraj"
else
    echo "You have logged in another user"
fi