# Runs tests against `install.sh`
# https://github.com/GochoMugo/grunt-install
#
# Copyright (c) 2014-2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License


# sourcing the `install.sh` script
source install.sh


# we assuming "git" is installed by our CI server
@test "grunt_is_installed: returns 0, if command is installed" {
  grunt_is_installed "git"
}


@test "grunt_is_installed: returns non-zero, if command is NOT installed" {
  ! grunt_is_installed "NOT_TO_BE_FOUND"
}


@test "grunt_check_requirements: loops through all reqs" {
  reqs=("git" "npm")
  result=`grunt_check_requirements reqs[@]`
  echo ${result} | grep "git" | grep "npm"
}


@test "grunt_check_requirements: returns 0 if all reqs installed" {
  reqs=("make" "cd")
  grunt_check_requirements reqs[@]
}


@test "grunt_check_requirements: returns non-zero not all reqs installed" {
  reqs=("make" "NOT_INSTALLED" "cd")
  ! grunt_check_requirements reqs[@]
}
