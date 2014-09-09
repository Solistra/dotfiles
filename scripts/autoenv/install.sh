#!/bin/sh

# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports the installation
# status, and exits with either 0 for success or 1 for failure.
report_status() {
	if [ $? -eq 0 ] ; then
		echo "autoenv installed to $loc."
		exit 0
	else
		echo 'autoenv failed to install.'
		echo "Check for remnants in $loc."
		exit 1
	fi
}
# scripted_install()
# -----------------------------------------------------------------------------
#   Provides automated installation for `autoenv`.
scripted_install() {
	if [ -d $loc ] ; then
		read -p "$loc exists. Overwrite? (y/n) " input
		[ "$input" != 'y' ] && return 2
		rm -rf $loc
	fi
	[ -x "$(which git)" ] || sudo apt-get install git
	echo 'Cloning autoenv source repository...'
	git clone git://github.com/kennethreitz/autoenv.git $loc
}
# =============================================================================
# Script Body
# =============================================================================
echo 'Installing autoenv...'
if [ -x "$(which brew)" ] ; then
	loc='/usr/local/opt/autoenv'
	brew update && brew install autoenv
else
	loc="$HOME/.autoenv"
	scripted_install
fi
report_status
