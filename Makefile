# Makefile for Developers and CI
# https://github.com/GochoMugo/grunt-install
#
# Copyright (c) 2014-2015 Gocho Mugo <mugo@forfuture.co.ke>
# Licensed under the MIT License

test:
	GRUNT_INSTALL_UNIT_TEST="test" bats test/test.install.sh
	GRUNT_INSTALL_UNIT_TEST="test" bats test/test.grunt-install.sh
	grunt
	make clean

clean:
	rm -rf _TEST_* npm-debug.log

.PHONY: test clean
