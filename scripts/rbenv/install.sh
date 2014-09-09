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
		echo 'rbenv and ruby-build installed to ~/.rbenv/bin/rbenv.'
		exit 0
	else
		echo 'rbenv and ruby-build failed to install.'	
		echo 'Check for remnants in ~/.rbenv.'
		exit 1
	fi
}
# scripted_install()
# -----------------------------------------------------------------------------
#   Provides automated installation for the `rbenv` command and `ruby-build`
# plugin.
scripted_install(){
	if [ -d $HOME/.rbenv ] ; then
		read -p "$HOME/.rbenv exists. Overwrite? (y/n) " input
		[ "$input" != 'y' ] && return 2
		rm -rf $HOME/.rbenv
	fi
	[ -x "$(which git)" ] || sudo apt-get install git
	echo 'Cloning rbenv source repository...'
	git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv
	echo 'Cloning ruby-build source repository...'
	git clone https://github.com/sstephenson/ruby-build.git \
		$HOME/.rbenv/plugins/ruby-build
}
# =============================================================================
# Script Body
# =============================================================================
echo 'Installing rbenv and ruby-build...'
if [ -x "$(which brew)" ] ; then
	brew update && brew install rbenv ruby-build
else
	scripted_install
fi
report_status
