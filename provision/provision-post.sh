maybe_update_file(){
	local SOURCE_FILE=$1
	local LOCAL_FILE=$2
	local APPEND=$3
	printf "\nChecking if $SOURCE_FILE needs installation or update...\n"
	if [ ! -e "$SOURCE_FILE" ]; then
		printf "Aborting test: source file does not exist: $SOURCE_FILE\n"
		return 1;
	elif [ ! -e "$LOCAL_FILE" ]; then
		printf "Destination file does not exist: $LOCAL_FILE\n"
		printf "Copying $SOURCE_FILE -> $LOCAL_FILE...\n"
		cp -p $SOURCE_FILE $LOCAL_FILE
		return $?;
	else
		HAS_DIFF=`diff --brief $LOCAL_FILE $SOURCE_FILE`
		if [ ! -z "$HAS_DIFF" ]; then
			printf "$HAS_DIFF\n"
			printf "Updating $LOCAL_FILE...\n"
			if [ -z "$APPEND" ]; then
				cp -p $SOURCE_FILE $LOCAL_FILE
			else
				cat "$SOURCE_FILE" >> "$LOCAL_FILE"
			fi
			return $?;
		else
			printf "No installation or update is needed.\n"
			return 0;
		fi
	fi
}

# Replace the default wp-config.php
maybe_update_file /srv/config/wordpress-config/wp-config.php /srv/www/wordpress-trunk/wp-config.php

# Bitbucket SSH key
printf "\nInstalling Bitbucket keys...\n"
maybe_update_file /srv/config/ssh/bitbucket.org_id_rsa.pub /home/vagrant/.ssh/bitbucket.org_id_rsa.pub
chown vagrant:vagrant /home/vagrant/.ssh/bitbucket.org_id_rsa.pub
chmod 600 /home/vagrant/.ssh/bitbucket.org_id_rsa.pub

maybe_update_file /srv/config/ssh/bitbucket.org_id_rsa /home/vagrant/.ssh/bitbucket.org_id_rsa
chown vagrant:vagrant /home/vagrant/.ssh/bitbucket.org_id_rsa
chmod 600 /home/vagrant/.ssh/bitbucket.org_id_rsa

maybe_update_file /srv/config/ssh/config /home/vagrant/.ssh/config append
chown vagrant:vagrant /srv/config/ssh/config
chmod 600 /srv/config/ssh/config

# COMPASS
if [ ! `which compass` ]; then
	printf "\nInstalling SASS and Compass...\n"
    gem update --system &&
    gem install sass --version 3.1.1
    gem install compass --version 0.11.1;
fi;

# Base mobile theme for VIP
if [ ! -d /srv/www/wordpress-trunk/wp-content/themes/pub/wp-mobile ]
then
	printf "\nDownloading wp-mobile theme...\n"
	mkdir /srv/www/wordpress-trunk/wp-content/themes/pub
	svn co https://wpcom-themes.svn.automattic.com/wp-mobile/ /srv/www/wordpress-trunk/wp-content/themes/pub/wp-mobile
else
	printf "\nUpdating wp-mobile theme...\n"
	svn up /srv/www/wordpress-trunk/wp-content/themes/pub/wp-mobile
fi

# VIP directory for VIP plugins and themes
if [ ! -d /srv/www/vip ]
then
	printf "\nCreating and linking VIP directory...\n"
	mkdir /srv/www/vip
	ln -sf /srv/www/vip /srv/www/wordpress-trunk/wp-content/themes/vip
fi

# VIP plugins
if [ ! -d /srv/www/vip/plugins ]
then
	printf "\nDownloading WordPress.com VIP plugins...\n"
	if [ ! -f /home/vagrant/.ssh/bitbucket.org_id_rsa.pub ]
	then
		printf "\nSkipping this step, SSH key has not been created.\n"
	else
		su -c 'git clone git@bitbucket.org:penskemediacorp/wordpress-vip-plugins.git /srv/www/vip/plugins' - vagrant
	fi
else
	printf "\nUpdating WordPress.com VIP plugins...\n"
	su -c 'cd /srv/www/vip/plugins; git pull --rebase origin master' - vagrant
fi

# pmc-plugins
if [ ! -d /srv/www/vip/pmc-plugins ]
then
	printf "\nDownloading pmc-plugins...\n"
	if [ ! -f /home/vagrant/.ssh/bitbucket.org_id_rsa.pub ]
	then
		printf "\nSkipping this step, SSH key has not been created.\n"
	else
		su -c 'git clone git@bitbucket.org:penskemediacorp/pmc-plugins.git /srv/www/vip/pmc-plugins' - vagrant
	fi
else
	printf "\nUpdating pmc-plugins...\n"
	su -c 'cd /srv/www/vip/pmc-plugins; git pull --rebase origin master' - vagrant
fi

# pmc-tvline-mobile theme
if [ ! -d /srv/www/vip/pmc-tvline-mobile ]
then
	printf "\nDownloading pmc-tvline-mobile theme...\n"
	if [ ! -f /home/vagrant/.ssh/bitbucket.org_id_rsa.pub ]
	then
		printf "\nSkipping this step, SSH key has not been created.\n"
	else
		su -c 'git clone git@bitbucket.org:penskemediacorp/pmc-tvline-mobile.git /srv/www/vip/pmc-tvline-mobile' - vagrant
	fi
else
	printf "\nUpdating pmc-tvline-mobile theme...\n"
	su -c 'cd /srv/www/vip/pmc-tvline-mobile; git pull --rebase origin master' - vagrant
fi

# pmc-master theme
if [ ! -d /srv/www/vip/pmc-master ]
then
	printf "\nDownloading pmc-master theme...\n"
	if [ ! -f /home/vagrant/.ssh/bitbucket.org_id_rsa.pub ]
	then
		printf "\nSkipping this step, SSH key has not been created.\n"
	else
		su -c 'git clone git@bitbucket.org:penskemediacorp/pmc-master.git /srv/www/vip/pmc-master' - vagrant
	fi
else
	printf "\nUpdating pmc-master theme...\n"
	su -c 'cd /srv/www/vip/pmc-master; git pull --rebase origin master' - vagrant
fi

# Set up shared plugins directory
if [ ! -d /srv/www/wordpress-plugins ]
then
	printf "\nCreating shared plugins directory\n"
	mkdir /srv/www/wordpress-plugins
	rm -rf /srv/www/wordpress-trunk/wp-content/plugins
	rm -rf /srv/www/wordpress-default/wp-content/plugins
	ln -sf /srv/www/wordpress-plugins /srv/www/wordpress-trunk/wp-content/plugins
	ln -sf /srv/www/wordpress-plugins /srv/www/wordpress-default/wp-content/plugins
	svn up /srv/www/wordpress-trunk/wp-content/plugins
	svn up /srv/www/wordpress-default/wp-content/plugins
fi

printf "\nUpdating plugins...\n"
wp --path=/srv/www/wordpress-trunk/ plugin update-all

PMC_SITES=(
	"bgr,bgr,BGR,bgr.dev"
	"pmc-411,pmc-411,Variety411,variety411.dev"
	"pmc-awardsline,pmc-awardsline,Awardsline,awardsline.dev"
	"pmc-deadline,pmc-deadline,Deadline,deadline.dev"
	"pmc-hollywoodlife,pmc-hollywoodlife,HollywoodLife,hollywoodlife.dev"
	"pmc-tvline,pmc-tvline,TVLine,tvline.dev"
	"pmc-variety,pmc-variety,Variety,variety.dev"
	)
PLUGINS=(
	"debug-bar-console"
	"debug-bar-cron"
	"debug-bar-extender"
	"debug-bar-super-globals"
	"debug-bar"
	"developer"
	"jetpack"
	"log-deprecated-notices"
	"log-viewer"
	"mp6"
	"polldaddy"
	"regenerate-thumbnails"
	"rewrite-rules-inspector"
	"user-switching"
	"vip-scanner"
	"vip-scanner"
	"wordpress-importer"
	)

for ROW in "${PMC_SITES[@]}"
do
	IFS=',' read -ra SITE_DATA <<< "$ROW"
	I=0
	for DATA in "${SITE_DATA[@]}"; do
		if [ $I == 0 ]; then
			REPO="$DATA"
		elif [ $I == 1 ]; then
			DESTINATION_DIR="$DATA"
		elif [ $I == 2 ]; then
			SITE_NAME="$DATA"
		elif [ $I == 3 ]; then
			DOMAIN="$DATA"
			export HTTP_HOST=$DOMAIN
		fi
		let I++
	done

	if [ ! -d "/srv/www/vip/$DESTINATION_DIR" ]
	then
		printf "\nDownloading $REPO theme...\n"
		if [ ! -f /home/vagrant/.ssh/bitbucket.org_id_rsa.pub ]
		then
			printf "\nSkipping this step, SSH key has not been created.\n"
		else
			su -c 'git clone git@bitbucket.org:penskemediacorp/'$REPO'.git /srv/www/vip/'$DESTINATION_DIR'' - vagrant
			wp core install --path=/srv/www/wordpress-trunk/ --url=$DOMAIN --quiet --title="$SITE_NAME" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password"

			# Install theme unit test data
			# As of Aug 14 2013 the theme-test command can't deal with global flags like --path, it must be run in the WordPress root folder.
			cd /srv/www/wordpress-trunk/
			wp theme-test install --option=skip --menus

			# Activate the theme
			wp theme activate vip/$DESTINATION_DIR
		fi
	else
		printf "\nUpdating $REPO theme...\n"
		su -c 'cd /srv/www/vip/'$DESTINATION_DIR'; git pull' - vagrant
	fi

	for PLUGIN in "${PLUGINS[@]}"
	do
		if [ ! -d "/srv/www/wordpress-plugins/$PLUGIN" ]
		then
			printf "\nInstalling plugin: $PLUGIN\n"
			wp --path=/srv/www/wordpress-trunk/ plugin install $PLUGIN
		fi
		printf "\nActivating plugin $PLUGIN for site $DOMAIN\n"
		wp --path=/srv/www/wordpress-trunk/ plugin activate $PLUGIN
	done
done
