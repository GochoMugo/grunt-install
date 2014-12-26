#!/bin/bash
# Install script for `grunt-install`
#
# Copyright (c) 2014 Gocho Mugo <mugo@forfuture.co.ke>


# checks if commands and utilities are installed on computer
# ${1}  command
# returns 0 for success. Otherwise, failure
grunt_is_installed() {
  type "${1}" > /dev/null 2>&1
}


# check if all requirements are satisfied
# ${1}  array of requirements
# returns 0 for success. Otherwise, failure
grunt_check_requirements() {
  echo "checking requirements..."
  declare -a reqs=${!1}
  exit_code=0
  for req in ${reqs[@]}
  do
    local answer="yes"
    if ! grunt_is_installed ${req} ; then
      answer="no"
      exit_code=1
    fi
    echo "    \"${req}\" installed: ${answer}"
  done
  return ${exit_code}
}


# When invoking unit tests this will avoid invoking installation process
[ ${GRUNT_INSTALL_UNIT_TEST} ] && return


# All requirements for `grunt-install`
requirements=("git" "npm")


# defaulting to install in /usr/bin
[ $# -eq 0 ] && INSTALL_DIR=/usr/local/bin || INSTALL_DIR=$1


# Invoking Installation
if grunt_check_requirements requirements[@] ; then
  echo "installing into ${INSTALL_DIR}"
  cp -p grunt-install.sh ${INSTALL_DIR}/grunt-install > /dev/null 2>&1
  [ $? -eq 0 ] && echo "successfully installed" || echo "ERROR: installation failed"
else
  echo "ERROR: requirements not satisfied"
fi
