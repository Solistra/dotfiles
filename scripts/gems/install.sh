#!/bin/sh

# =============================================================================
# Functions
# =============================================================================
# report_status()
# -----------------------------------------------------------------------------
#   Determines installation status from the given argument and exits with
# either 0 for success or 1 for failure.
report_status(){
	if [ "$1" = '0' ] ; then
		echo 'All gems successfully installed.'
		exit 0
	else
		echo "$1 gems were not successfully installed."
		exit 1
	fi
}
# scripted_install()
# -----------------------------------------------------------------------------
#   Automates installation of standard Ruby gems.
scripted_install(){
	local errtotal=0
	for ruby_gem in benchmark-ips bundler observr pry rake rspec ; do
		echo "Installing $ruby_gem..."
		gem install --conservative $ruby_gem
		[ $? -eq 0 ] || errtotal=$(( $errtotal + 1 ))
	done
	return $errtotal
}
# =============================================================================
# Script Body
# =============================================================================
[ -x "$(which ruby)" ] || sudo apt-get install ruby1.9.1
if [ -x "$(which rbenv)" ] ; then
	for ruby_version in $(rbenv whence ruby | xargs) ; do
		echo "Installing gems for $ruby_version..."
		export RBENV_VERSION=$ruby_version
		scripted_install
		errtotal=$(( $errtotal + $? ))
	done
	rbenv rehash ; unset RBENV_VERSION
else
	sudo scripted_install
	errtotal=$?
fi
report_status $errtotal
