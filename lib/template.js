/**
 * template wrapper
 * https://github.com/forfuture-dev/grunt-install
 *
 * Copyright (c) 2014 Forfuture LLC
 * Licensed under the MIT License
 */


/**
* Trying to load any package.json that may be in `root/package.json`
*/
var originalProps;
try {
  originalProps = require(__dirname + "/root/package.json");
} catch (error) {
  originalProps = {};
}


exports.description = "A grunt template";
exports.after = "Install dependencies with `npm install`";

exports.template = function(grunt, init, done) {
  init.process(originalProps, [
    init.prompt("name"),
    init.prompt("author_name"),
    init.prompt("author_email"),
    init.prompt("author_url"),
    init.prompt("repository"),
    init.prompt("licenses", "MIT")
  ], function(err, props) {
    var files = init.filesToCopy(props);
    init.addLicenseFiles(files, props.licenses);
    init.copyAndProcess(files, props);
    init.writePackageJSON("package.json", props);
    done();
  });
};
