!# /usr/bin/sh

echo Hello $USER
echo "Do you want to Continue with current user $USER (yes or no)" 
read input


if [ $input == "yes" ]
then
        echo "Welcome $USER"

elif [$input == "no" ]  
then
    echo "Enter User"

else 
    echo "You have entered incorrect options"
fi

update_system() {
    sudo apt update -y
    echo "sussess"
}