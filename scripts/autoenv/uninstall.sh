#!/bin/sh

# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Checks the exit status of the last run command, reports uninstallation
# status, and exits with either 0 for success or 1 for failure.
# 
# NOTE: This script may also exit with a status of 2 if `autoenv` is not
# installed.
report_status(){
	if [ $? -eq 0 ] ; then
		echo 'autoenv uninstalled.'
		exit 0
	else
		echo 'autoenv could not be uninstalled!'
		echo "Check for remnants in $loc."
		exit 1
	fi
}
# =============================================================================
# Script Body
# =============================================================================
if [ -d $HOME/.autoenv ] || [ -d /usr/local/opt/autoenv ] ; then
	echo 'Uninstalling autoenv...'
	if [ -x "$(which brew)" ] ; then
		loc='/usr/local/opt/autoenv'
		brew rm autoenv
	else
		loc="$HOME/.autoenv"
		rm -rf $loc
	fi
	report_status
else
	echo 'autoenv is not installed!'
	exit 2
fi
