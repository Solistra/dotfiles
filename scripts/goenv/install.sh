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
		echo 'goenv installed to ~/.goenv/bin/goenv.'
		exit 0
	else
		echo 'goenv failed to install.'	
		echo 'Check for remnants in ~/.goenv.'
		exit 1
	fi
}
# scripted_install()
# -----------------------------------------------------------------------------
#   Provides automated installation for the `goenv` command.
# 
# NOTE: This installs my own personal fork of `goenv`. The original may be
# found at https://github.com/wfarr/goenv.
scripted_install(){
	if [ -d $HOME/.goenv ] ; then
		read -p "$HOME/.goenv exists. Overwrite? (y/n) " input
		[ "$input" != 'y' ] && return 2
		rm -rf $HOME/.goenv
	fi
	[ -x "$(which git)" ] || sudo apt-get install git
	echo 'Cloning goenv (bugfix) source repository...'
	git clone -b bugfix https://github.com/Solistra/goenv.git $HOME/.goenv
}
# =============================================================================
# Script Body
# =============================================================================
echo 'Installing goenv...'
scripted_install
report_status
