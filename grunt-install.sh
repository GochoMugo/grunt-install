#!/bin/bash
# Grunt Template Installer
#
# Copyright (c) 2014 Gocho Mugo <mugo@forfuture.co.ke>


# Version Number
GRUNT_INSTALL_VERSION="0.0.0"


# Colors for Bash
GRUNT_COLOR_BLUE="\033[0;34m"
GRUNT_COLOR_GREEN="\033[0;32m"
GRUNT_COLOR_RED="\033[0;31m"
GRUNT_COLOR_RESET="\e[0m"
GRUNT_COLOR_WHITE="\033[1;37m"


# installs from Github
#
# ${1}  github shorthand e.g. GochoMugo/grunt-install
# ${2}  destination directory
grunt_install_from_github() {
  local full_url="https://github.com/${1}.git"
  git clone ${full_url} ${2} > /dev/null 2>&1
}


# determining if ${1} is a Github shorthand
#
# ${1}  shorthand to test
grunt_is_github_shorthand() {
  echo ${1} | grep ".*/.*" > /dev/null 2>&1
}


# installs from npmjs.org
#
# ${1}  package-name
# ${2} destination directory
grunt_install_from_npmjs() {
  mkdir -p ${2}
  npm install ${1} --prefix ${2} > /dev/null 2>&1
  if [ -d ${2}/node_modules/${1} ] ; then
    cp -r ${2}/node_modules/${1}/* ${2}
    rm -rf ${2}/node_modules
  else
    rm -rf ${2}
    return 1
  fi
}


# logs to console
#
# ${1}  message to write to console
# ${2} what color to use. 0 - info(blue), 1- success(green), 2 - error(red)
grunt_log() {
  if [ ! ${GRUNT_INSTALL_NO_COLOR} ] ; then
    [ ${2} -eq 0 ] && local color=${GRUNT_COLOR_BLUE}
    [ ${2} -eq 1 ] && local color=${GRUNT_COLOR_GREEN}
    [ ${2} -eq 2 ] && local color=${GRUNT_COLOR_RED}
    echo -e "${GRUNT_COLOR_WHITE}grunt-install: ${color}${1}${GRUNT_COLOR_RESET}"
  else
    echo "grunt-install: ${1}"
  fi
}


# initializes installation
grunt_install() {
  local dest_dir=~/.grunt-init/${2}
  if [ -d ${dest_dir} ] ; then
    grunt_log "a template with same name exists" 2
    grunt_log "try a different name" 2
    exit 1
  fi
  if grunt_is_github_shorthand ${1} ; then
    grunt_log "installing from github" 0
    grunt_install_from_github ${1} ${dest_dir}
  else
    grunt_log "installing from npm" 0
    grunt_install_from_npmjs ${1} ${dest_dir}
  fi
  if [ $? ] && [ -d ${dest_dir} ] ; then
    grunt_log "template installed as '${2}'" 1
    return 0
  fi
  grunt_log "installation failed" 2
  return 1
}


# show help information
grunt_show_help() {
  echo "grunt-install"
  echo
  echo "Usage: grunt-install <URI> <template_name>"
  echo
  echo "Where <URI> can be:"
  echo "    UserName/RepoName    github shorthand"
  echo "    PackageName          npm package name"
  echo
  echo "More Options:"
  echo "    --help               Show this help information"
  echo "    --version            Show version information"
  echo
  echo "Examples:"
  echo "    grunt-install forfuture-dev/grunt-template-esta MyTemplate"
  echo "    grunt-install grunt-template-esta AwesomeNess"
}


# shows version information
grunt_show_version() {
  grunt_log "${GRUNT_INSTALL_VERSION}" 0
}


# When invoking unit tests this will avoid invoking installation process
[ ${GRUNT_INSTALL_UNIT_TEST} ] && return


# Parsing Arguments. At least 1 argument is required.
# ${1}  template_source
# ${2}  [preffered_name]
case $1 in
  "--help" )
    grunt_show_help ;;
  "--version" )
    grunt_show_version ;;
  * )
    # if less/excess command-line arguments are passed, error is shown
    if [ $# -ne 2 ] ; then
      grunt_log "less/excess arguments" 2
      grunt_log "try \`--help' for help information" 2
      exit 1
    fi
    grunt_install ${1} ${2} ;;
esac
