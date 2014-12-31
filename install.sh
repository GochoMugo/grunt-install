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
requirements=("git" "npm" "rsync")


# defaulting to install in /usr/bin
[ $# -eq 0 ] && INSTALL_BIN=/usr/local/bin || INSTALL_BIN=$1


# resolving a lib directory
INSTALL_DIR="$(dirname ${INSTALL_BIN})/lib/grunt-install"


# Invoking Installation
if grunt_check_requirements requirements[@] ; then
  echo "installing: ${INSTALL_DIR}"
  mkdir -p ${INSTALL_DIR}
  cp -fpr grunt-install.sh lib ${INSTALL_DIR}
  echo "linking: ${INSTALL_DIR}/grunt-install.sh -> ${INSTALL_BIN}/grunt-install"
  ln -fs ${INSTALL_DIR}/grunt-install.sh ${INSTALL_BIN}/grunt-install
  [ $? -eq 0 ] && echo "successfully installed" || echo "ERROR: installation failed"
else
  echo "ERROR: requirements not satisfied"
fi
