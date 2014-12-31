#!/bin/bash
# Grunt Template Installer
#
# Copyright (c) 2014 Gocho Mugo <mugo@forfuture.co.ke>


# Version Number
GRUNT_INSTALL_VERSION="0.0.0"


# Template Directory
GRUNT_TEMPLATE_DIRECTORY=~/.grunt-init


# Colors for Bash
GRUNT_COLOR_BLUE="\033[0;34m"
GRUNT_COLOR_GREEN="\033[0;32m"
GRUNT_COLOR_RED="\033[0;31m"
GRUNT_COLOR_RESET="\e[0m"
GRUNT_COLOR_WHITE="\033[1;37m"


# Script Variables
GRUNT_INSTALL_FORCE=false
GRUNT_INSTALL_SILENT=false


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


# wraps template for grunt-init, updating
#
# ${1}  package directory path
# ${2}  command to run to update template
grunt_wrap_template() {
  if [ ! -e "${1}/template.js" ] && [ ! -d "${1}/root" ] ; then
    rsync --remove-source-files -r ${1}/* ${1}/root
    rmdir ${1}/* --ignore-fail-on-non-empty --parents
    cp lib/template.js ${1}
  fi
  echo "GRUNT_TEMPLATE_UPDATE=${2}" >> ${1}/.grunt-install.config
}


# logs to console
#
# ${1}  message to write to console
# ${2} what color to use. 0 - info(blue), 1- success(green), 2 - error(red)
grunt_log() {
  if [ ${GRUNT_INSTALL_SILENT} == true ] ; then return ; fi
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
  local dest_dir=${GRUNT_TEMPLATE_DIRECTORY}/${2}
  if [ -d ${dest_dir} ] && [ ${GRUNT_INSTALL_FORCE} == false ] ; then
    grunt_log "a template with same name exists" 2
    grunt_log "try a different name" 2
    exit 1
  fi
  rm -rf ${dest_dir} > /dev/null 2>&1
  if grunt_is_github_shorthand ${1} ; then
    grunt_log "installing from github" 0
    grunt_install_from_github ${1} ${dest_dir}
  else
    grunt_log "installing from npm" 0
    grunt_install_from_npmjs ${1} ${dest_dir}
  fi
  if [ $? ] && [ -d ${dest_dir} ] ; then
    grunt_wrap_template ${dest_dir} ${1}
    grunt_log "template installed as '${2}'" 1
    return 0
  fi
  grunt_log "installation failed" 2
  return 1
}


# updates grunt templates
grunt_update_templates() {
  for template in ${GRUNT_TEMPLATE_DIRECTORY}/*/ ; do
    if [ -r ${template}/.grunt-install.config ] ; then
      template_name=$(basename ${template})
      source ${template}/.grunt-install.config
      ./grunt-install.sh ${GRUNT_TEMPLATE_UPDATE} ${template_name} --force --silent \
      && grunt_log "updated: ${template_name}" 1 \
      || grunt_log "failed to update: ${template_name}" 2
    fi
  done
}


# process arguments
grunt_process_arg() {
  case ${1} in
    "-f" | "--force")
      GRUNT_INSTALL_FORCE=true ;;
    "-s" | "--silent")
      GRUNT_INSTALL_SILENT=true ;;
  esac
}


# upgrade grunt-install
# Note: only clones from github once
#
# ${1}  option passed to installation script
grunt_upgrade() {
  grunt_log "upgrading myself" 0
  git clone https://github.com/GochoMugo/grunt-install /tmp/grunt-install-upgrade > /dev/null 2>&1
  /tmp/grunt-install-upgrade/install.sh ${1} > /dev/null 2>&1 \
  && grunt_log "successful upgrade" 1 \
  || grunt_log "failed to upgrade" 2
}


# show help information
grunt_show_help() {
  echo "grunt-install ${GRUNT_INSTALL_VERSION}"
  echo
  echo "Usage: grunt-install [install_options] <URI> <template_name>"
  echo
  echo "Where <URI> can be:"
  echo "    UserName/RepoName    github shorthand"
  echo "    PackageName          npm package name"
  echo
  echo "Install Options:"
  echo "    -f,  --force         Force installation"
  echo "    -s,  --silent        Be Silent"
  echo
  echo "More Options:"
  echo "    -h,  --help          Show this help information"
  echo "    -u,  --update        Update installed templates"
  echo "    -up, --upgrade       Upgrade grunt-install"
  echo "    -v,  --version       Show version information"
  echo
  echo "Examples:"
  echo "    grunt-install forfuture-dev/grunt-template-esta MyTemplate"
  echo "    grunt-install grunt-template-esta AwesomeNess"
}


# shows version information
grunt_show_version() {
  grunt_log "${GRUNT_INSTALL_VERSION} by GochoMugo <mugo@forfuture.co.ke>" 0
  grunt_log "repo at https://github.com/GochoMugo/grunt-install" 0
}


# When invoking unit tests this will avoid invoking installation process
[ ${GRUNT_INSTALL_UNIT_TEST} ] && return


# Parsing Arguments. At least 1 argument is required.
# ${1}  template_source
# ${2}  [preffered_name]
case ${1} in
  "-h" | "--help" )
    grunt_show_help ;;
  "-v" | "--version" )
    grunt_show_version ;;
  "-u" | "--update")
    grunt_update_templates ;;
  "-up" | "--upgrade")
    grunt_upgrade ${2} ;;
  * )
    declare -a args
    index=0
    # processing install options
    for arg in $@ ; do
      if [[ ${arg} == -* ]] ; then
        grunt_process_arg ${arg}
      else
        args[index]=${arg}
        ((index++))
      fi
    done
    # if less/excess command-line arguments are passed, error is shown
    if [ ${#args[@]} -lt 2 ] || [ $# -lt 2 ] ; then
      grunt_log "missing arguments" 2
      grunt_log "try \`--help' for help information" 2
      exit 1
    fi
    grunt_install ${args[0]} ${args[1]} ;;
esac
