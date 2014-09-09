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
		echo 'hub installed to /usr/local/bin/hub.'
		exit 0
	else
		echo 'hub failed to install.'
		exit 1
	fi
}
# scripted_install()
# -----------------------------------------------------------------------------
#   Provides automated installation for the `hub` command when `brew` is not
# available.
# 
# NOTE: This function is intended to be used on systems with Debian package
# management and `sudo` available to execute commands as root.
scripted_install() {
	# `homebrew` is not installed, so manage the installation manually.
	if [ -d /usr/local/src/hub ] ; then
		read -p '/usr/local/src/hub exists. Overwrite? (y/n) ' input
		[ "$input" != 'y' ] && return 2
		sudo rm -rf /usr/local/src/hub
	fi
	# Ensure that we have `git` installed.
	[ -x "$(which git)" ] || sudo apt-get install git
	echo 'Cloning hub source repository...'
	sudo git clone git://github.com/github/hub.git /usr/local/src/hub
	if [ $? -eq 0 ] ; then
		# The `git clone` command succeeded, proceed with installation.
		cd /usr/local/src/hub
		if [ ! -x "$(which rake)" ] ; then
			# Get `ruby` and `rake` if we don't already have them.
			[ -x "$(which ruby)" ] || sudo apt-get install ruby1.9.1
			gem install rake
		fi
		echo 'Performing `rake install` task as root...'
		sudo rake install
	else
		# The `git clone` command failed, abort installation.
		echo 'git failed to clone hub, aborting...'
		return 1
	fi
}
# =============================================================================
# Script Body
# =============================================================================
if [ -x "$(which brew)" ] ; then
	brew update && brew install hub
else
	scripted_install
fi
report_status
