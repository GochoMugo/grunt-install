
# grunt-install

Simple Bash script for Grunt template installation


## installation:

This method clones the Github repository and runs the `install.sh` script in
 the newly-created directory.

```bash
⇒ git clone https://github.com/GochoMugo/grunt-install.git
⇒ cd grunt-install
⇒ ./install.sh
```


## usage:

__grunt-install__ allows you to install Grunt templates from both Github
 and NPM online registry with much ease.

To install a template from Github, such as [this one][esta], simply run:

```bash
⇒ grunt-install forfuture-dev/grunt-template-esta MyTemplate
```

This uses a Github shorthand which will be expanded to match the Github
 Repository URL. You also provide a name, in this case `MyTemplate`, that
 will be given to the template.

You may also install templates from NPM online registry, by simply
 running:

```bash
⇒ grunt-install grunt-template-esta MyTemplate
```

Once templates are installed, you may now use [grunt-init][grunt-init] to
 initiate a Grunt project.

```bash
⇒ grunt-init MyTemplate
```


## tips:

Lets say we version bump and you want to upgrade to the latest version
 __grunt-install__, it is simple:

```bash
⇒ grunt-install --upgrade
```

In the spirit of keeping up to date, you want to update your templates:

```bash
⇒ grunt-install --update
```

If you ever want to replace a template with another while installing, you
 could simply use the `--force` option. Example:

```bash
⇒ grunt-install --force forfuture-dev/grunt-template-esta esta
```


## help information:

```bash
⇒ grunt-install --help
grunt-install 0.0.0

Usage: grunt-install [install_options] <URI> <template_name>

Where <URI> can be:
    UserName/RepoName    github shorthand
    PackageName          npm package name

Install Options:
    -f,  --force         Force installation
    -s,  --silent        Be Silent

More Options:
    -h,  --help          Show this help information
    -u,  --update        Update installed templates
    -up, --upgrade       Upgrade grunt-install
    -v,  --version       Show version information

Examples:
    grunt-install forfuture-dev/grunt-template-esta MyTemplate
    grunt-install grunt-template-esta AwesomeNess
```


## more information:

Setting the environment variable `GRUNT_INSTALL_NO_COLOR` will
 disable color output.


## license:

The MIT License (MIT)

Copyright (c) 2014 Gocho Mugo <mugo@forfuture.co.ke>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to
whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall
be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[esta]:https://github.com/forfuture-dev/grunt-template-esta
[grunt-init]:https://github.com/gruntjs/grunt-init
