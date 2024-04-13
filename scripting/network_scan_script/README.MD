#### 1. Color Code
```
Sr.No	 	Color Code		Color Name			Example
			
1 			\033[30m		black             echo -e "\033[30m####\033[m" 
2  			\033[31m		red               echo -e "\033[31m####\033[m"                                       
3  			\033[32m		green             echo -e "\033[32m####\033[m"                                       
4  			\033[33m		yellow            echo -e "\033[33m####\033[m"                                       
5  			\033[34m		blue              echo -e "\033[34m####\033[m"                                       
6  			\033[35m 		purple            echo -e "\033[35m####\033[m"   
7  			\033[36m       	cyan              echo -e "\033[36m####\033[m"                                       
8  			\033[37m       	white             echo -e "\033[37m####\033[m"                              
```

#### 2. color-mode
```
It modifies the style of color NOT text. For example make the color bright or darker.

    0 reset
    1; lighter than normal
    2; darker than normal

This mode is not supported widely. It is fully support on Gnome-Terminal.
```
#### 3. text-mode
```
This mode is for modifying the style of text NOT color.

    1; italic
    2; underline
    3; blinking (slow)
    4; blinking (fast)
    5; reverse
    6; hide
    7; cross-out
```
