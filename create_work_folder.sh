base_folder="/home/ncho/1T"
banch_name=$1
cd $base_folder
if [ -d "$banch_name" ]; then
        echo "has folder!!!!"
        cd $base_folder/$banch_name
        if [ -d "android" ]; then
            echo "has android folder!!!!"
        else
            echo "no android folder!!!"
            mkdir $base_folder/$banch_name/adnroid/ -p
            cp /home/ncho/1T/V4A_main/android/.repo -rf $base_folder/$banch_name/adnroid/
            cd $base_folder/$banch_name/adnroid/
            /usr/local/bin/repo sync -cj4
        fi
        if [ -d "foundation" ]; then
            echo "has foundation folder!!!!"
        else
            echo "no foundation folder!!!"
            mkdir $base_folder/$banch_name/foundation -p
            cp /home/ncho/1T/V4A_main/foundation/.repo -rf $base_folder/$banch_name/foundation/
            cd $base_folder/$banch_name/foundation
            /usr/local/bin/repo sync -cj4
        fi
else
	echo "no folder!!!"
        mkdir $base_folder/$banch_name/adnroid/ -p
        mkdir $base_folder/$banch_name/foundation -p
        cp /home/ncho/1T/V4A_main/android/.repo -rf $base_folder/$banch_name/adnroid/
        cp /home/ncho/1T/V4A_main/foundation/.repo -rf $base_folder/$banch_name/foundation/
        cd $base_folder/$banch_name/adnroid/
        /usr/local/bin/repo sync -cj4
        cd $base_folder/$banch_name/foundation
        /usr/local/bin/repo sync -cj4 
fi
