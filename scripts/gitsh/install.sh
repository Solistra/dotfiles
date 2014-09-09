#!/bin/sh

# =============================================================================
# Variables
# =============================================================================
version='0.7'
# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports the installation
# status, and exits with either 0 for success or 1 for failure.
report_status() {
	if [ $? -eq 0 ] ; then
		echo 'gitsh installed to /usr/local/bin/gitsh.'
		exit 0
	else
		echo 'gitsh failed to install.'
		echo 'Check for remnants in /usr/local and /tmp.'
		exit 1
	fi
}
# scripted_install()
# -----------------------------------------------------------------------------
#   Provides automated installation for the `gitsh` command when `brew` is not
# available.
# 
# NOTE: This function is intended to be used on systems with Debian package
# management and `sudo` available to execute commands as root.
scripted_install() {
	# `homebrew` is not installed, so manage the installation manually.
	if [ -d "/usr/local/src/gitsh-$version" ] ; then
		read -p "/usr/local/src/gitsh-$version exists. Overwrite? (y/n) " input
		[ "$input" != 'y' ] && return 2
		sudo rm -rf /usr/local/src/gitsh
	fi
	# Ensure that we have `wget` installed, download and extract `gitsh`.
	[ -x "$(which wget)" ] || sudo apt-get install wget
	echo "Downloading gitsh v$version release..."
	sudo wget -P /tmp "https://github.com/thoughtbot/gitsh/releases/download/v$version/gitsh-$version.tar.gz" && 
	sudo mkdir -p /usr/local/src/gitsh &&
	sudo tar xzvf "/tmp/gitsh-$version.tar.gz" -C /usr/local/src &&
	# Remove the temporary .tar.gz archive.
	sudo rm -f "/tmp/gitsh-$version.tar.gz"
	if [ $? -eq 0 ] ; then
		# The extraction succeeded, proceed with installation.
		cd "/usr/local/src/gitsh-$version"
		[ -x "$(which ruby)" ] || sudo apt-get install ruby1.9.1
		[ -x "$(which make)" ] || sudo apt-get install build-essential
		echo 'Configuring gitsh...'
		sudo ./configure
		echo 'Running `make` and `make install` task...'
		sudo make && sudo make install
	else
		# The extraction failed, abort installation.
		echo 'Failed to download and extract gitsh release, aborting...'
		return 1
	fi
}
# =============================================================================
# Script Body
# =============================================================================
echo 'Installing gitsh...'
if [ -x "$(which brew)" ] ; then
	brew update && brew install gitsh
else
	scripted_install
fi
report_status
