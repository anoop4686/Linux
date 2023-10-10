#! /usr/bin/bash

echo "Enter the 1st Number : "
read num1

echo "Enter the 2nd Number : "
read num2

echo "Select the Operation" 
echo "1 - Addition" 
echo "2 - Subscription"
echo "3 - Multiplication" 
echo "4 - Division"
echo "5 - Module"
echo "6 - Exponents"

read input;

if [ $input == 1 ]
then
  result=$(($num1 + $num2)) 
  echo "Then result of Two number is $num1 and $num2 is : $result"
elif [ $input == 2 ]
then
  result=$(($num1 - $num2)) 
  echo "Then result of Two number is $num1 and $num2 is : $result"
elif [ $input == 3 ]
then
  result=$(($num1 * $num2)) 
  echo "Then result of Two number is $num1 and $num2 is : $result"
elif [ $input == 4 ]
then
  result=$(($num1 / $num2)) 
  echo "Then result of Two number is $num1 and $num2 is : $result"
elif [ $input == 5 ]
then
  result=$(($num1 % $num2)) 
  echo "Then result of Two number is $num1 and $num2 is : $result"
elif [ $input == 6 ]
then
  result=$(($num1 // $num2)) 
  echo "Then result of Two number is $num1 and $num2 is : $result"
else
  echo "You have entered Wrong Input"
fi