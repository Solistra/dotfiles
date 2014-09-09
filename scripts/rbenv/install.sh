#!/bin/sh

# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports the installation
# status, and exits with either 0 for success or 1 for failure.
report_status(){
	if [ $? -eq 0 ] ; then
		echo "rbenv and ruby-build installed to $loc."
		exit 0
	else
		echo 'rbenv and ruby-build failed to install.'	
		echo "Check for remnants in $loc."
		exit 1
	fi
}
# scripted_install()
# -----------------------------------------------------------------------------
#   Provides automated installation for the `rbenv` command and `ruby-build`
# plugin.
scripted_install(){
	if [ -d $loc ] ; then
		read -p "$loc exists. Overwrite? (y/n) " input
		[ "$input" != 'y' ] && return 2
		rm -rf $loc
	fi
	[ -x "$(which git)" ] || sudo apt-get install git
	echo 'Cloning rbenv source repository...'
	git clone https://github.com/sstephenson/rbenv.git $loc
	echo 'Cloning ruby-build source repository...'
	git clone https://github.com/sstephenson/ruby-build.git \
		"$loc/plugins/ruby-build"
}
# =============================================================================
# Script Body
# =============================================================================
echo 'Installing rbenv and ruby-build...'
if [ -x "$(which brew)" ] ; then
	loc='/usr/local/opt/rbenv'
	brew update && brew install rbenv ruby-build
else
	loc="$HOME/.rbenv"
	scripted_install
fi
report_status
