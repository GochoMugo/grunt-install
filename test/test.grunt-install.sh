# Runs tests against `grunt-install.sh`
#
# Copyright (c) 2014 Gocho Mugo <mugo@forfuture.co.ke>


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
