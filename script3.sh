
#!/bin/bash
 echo "-----------------------------Script for creating user----------------------"
 echo -e "\n\n"
 echo "Text document which contains users should beplaced in directory src"
 echo -e "\n"
 read -p "Enter name of the file which contains users witch params: " FILE_USERS

 USERS_PATH="./src/$FILE_USERS"

 if [[ -f $USERS_PATH ]]; then
 	     IFS=$'\n'

         for LINE in `cat $USERS_PATH`
 	     do

 	     		username=`echo "$LINE" | cut -d ":" -f1`
 	     		user_group=`echo "$LINE" | cut -d ":" -f2`
 	     		user_password=`echo "$LINE" | cut -d ":" -f3`
 	     		ssl_password=`openssl passwd -1 $user_password`
 	     		user_shell=`echo "$LINE" | cut -d ":" -f4`
 	     		if ! grep -q $username "/etc/passwd" ; then
 	     			    echo -e "$username was not found in the system!"
 	     			    read -p "Do you want tocreate a new  user $username? [yes/no]" ANS_NEW
                        case $ANS_NEW in
		                     [Yy]|[yY][Ee][Ss])
		 	     			 if [[ `grep $user_group /etc/group` ]]; then
                                 echo "Group $user_group already exists in system"
                                 useradd $username -s $user_shell -m -g $user_group -p $ssl_password
                             else
                             	echo -e "Group $user_group doesn't exists in the system\nIt will be create!"
                             	groupadd $user_group
                             	useradd $username -s user_shell -m -g $user_group -p $ssl_password
                             fi
                             echo -e "User $username was created!\n"
                             ;;
                        [Nn]|[nN][Oo])
                             echo -e "The creation of user $username will skip!\n"
                             ;;
                        *)
                esac
 	     	 elif [[ 'grep $username "/etc/passwd"' ]] ; then
 	     			 echo "$username was found in system!"
 	     			 read -p "Do you want to make some changes for $username ? (yes/no)" ANSWER_CHANGES
 	     			 case $ANSWER_CHANGES in
 	     			     [Yy]|[Yy][Ee][Ss])
							 echo "You answered yes!";;
						[Nn]|[Nn][Oo])
 	     			         echo "You answered no!";;
 	     			    *)
                             echo "You need to enter only YES/NO!!!";;
                esac

            fi
    done

else
	                  echo "$FILE_USERS doesn' t exist"
	                  echo "You need to create a new file"
fi




