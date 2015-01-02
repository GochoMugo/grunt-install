/**
 * grunt tasks
 * https://github.com/GochoMugo/grunt-install
 *
 * Copyright (c) 2014-2015 Forfuture LLC
 * Licensed under the MIT License
 */


module.exports = function(grunt) {
  grunt.initConfig({
    jshint: {
      template: {
        src: ["Gruntfile.js", "lib/template.js"]
      }
    }
  });

  grunt.loadNpmTasks("grunt-contrib-jshint");

  grunt.registerTask("default", ["jshint"]);
};
