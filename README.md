#Overview

This repository is for easily deploying our Gulp workflow. Currently, we only have one command available but aim to have a command for each step of the web development timeline. 

##Download

To get the gulp-workflow install script, `cd` to your project's directory and run the following `wget` command.

`wget https://raw.githubusercontent.com/rapidwebltd/gulp-workflow/master/INSTALL.sh`

#Usage
Run the `./INSTALL.sh` script from your Ubuntu machine. It should be saved inside the working project's root directory.

If you receive a `Permission denied` error, you need to make the script executable with `chmod +x INSTALL.sh`.

##Commands

`gulp watch`

(Keeps an eye on your Bootstrap and LESS files by runs Bootlint and Lessc upon file changes)

##Default Directories
By default the script looks for Bootstrap, LESS, JS files in the following locations, these can be edited when running the script, if required:
###Bootstrap
`'./*.html', './index.php', './**/*.html', './**/*.php'`

###LESS
`'./*.less', './**/*.less'`

###CSS Output
`'./css/style.css'`

##JavaScript
`'./*.js', './**/*.js'`

#License
MIT

##Todo: 

* Initial JSHint support (In Progress)
* OSX support
* Redhat/Fedora support
* Further error catching

