# Runs tests against `grunt-install.sh`
# https://github.com/GochoMugo/grunt-install
#
# Copyright (c) 2014-2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License


# sourcing `grunt-install.sh`
source grunt-install.sh


@test "grunt_install_from_github: installs at path passed" {
  grunt_install_from_github "forfuture-dev/grunt-template-esta" \
    "_TEST_github1"
}


@test "grunt_install_from_github: fails if no such github exists" {
  skip
  ! grunt_install_from_github "GochoMugo/NO_SUCH_REPO" \
    "_TEST_github2"
}


@test "grunt_is_github_shorthand: returns 0 if it is github shorthand" {
  grunt_is_github_shorthand "forfuture-dev/grunt-template-esta"
}


@test "grunt_is_github_shorthand: returns non-Zero if not github shorthand" {
  ! grunt_is_github_shorthand "SOME_NON_GITHUB_SHORTHAND"
}


@test "grunt_install_from_npmjs: installs at path passed" {
  grunt_install_from_npmjs "sequential-ids" "_TEST_npmjs1"
}


@test "grunt_install_from_npmjs: fails if no such package is registered" {
  ! grunt_install_from_npmjs "GOCHO_CANT_BE_A_PACKAGE" \
    "_TEST_npmjs2"
}


make_fake_template() {
  mkdir ${1}
  mkdir ${1}/lib
  touch ${1}/a.js ${1}/lib/b.js
}


@test "grunt_wrap_template: wraps template for grunt-init" {
  make_fake_template "_TEST_grunt_wrap_1"
  grunt_wrap_template "_TEST_grunt_wrap_1" "boom"
  [ -r _TEST_grunt_wrap_1/template.js ] \
    && [ -d _TEST_grunt_wrap_1/root ]
}


@test "grunt_log: enables silence" {
  GRUNT_INSTALL_SILENT=true
  grunt_log "Wont show up on console" 0 > _TEST_grunt_log_file
  [ $(grep -c -E "*" _TEST_grunt_log_file) -eq 0 ]
}
