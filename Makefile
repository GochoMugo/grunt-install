
test:
	GRUNT_INSTALL_UNIT_TEST="test" bats test/test.install.sh
	GRUNT_INSTALL_UNIT_TEST="test" bats test/test.grunt-install.sh
	make clean

clean:
	rm -rf _TEST_* npm-debug.log

.PHONY: test
