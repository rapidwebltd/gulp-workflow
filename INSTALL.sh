#!/bin/bash
ask() {
    # http://djm.me/ask
    while true; do
 
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
 
        # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
        read -p "$1 [$prompt] " REPLY </dev/tty
 
        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
 
        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
 
    done
}

if ask "WARNING: This script is currently ONLY designed for Ubuntu 14.04) Are you sure you wish to proceed?" Y; then
    INSTALL=()
    echo "Checking Nodejs & NPM are installed..."
    #Check to see if 'nodejs' is installed
    if ! type -P nodejs > /dev/null; then
    	INSTALL+=('nodejs ');
	fi
	#Check to see if 'npm' is installed
	if ! type -P npm > /dev/null; then
    	INSTALL+=('npm ');	   
	fi
	if [ ${#INSTALL[@]} -gt 0 ]; then
		echo "Installing ${INSTALL[@]}...";
		sudo apt-get install ${INSTALL[@]} -y;
	fi
	if ! type -P node > /dev/null; then
		sudo ln -s /usr/bin/nodejs /usr/bin/node
	fi
	echo "Installed! Moving on...";

	#NPM modules installation...
	echo "Installing Gulp globally..."
	sudo npm install --global gulp 
	#clear
	echo "Installing basic gulp tasks..."
	npm install require-dir 
	npm install --save-dev gulp gulp-require jshint-stylish gulp-minify-css gulp-less path gulp-watch gulp-html5-lint gulp-jshint gulp-livereload gulp-bootlint
	clear
	if ask "Would you like to specify your own file paths for your Bootstrap/LESS/JS files? (Defaults: './*.html', './index.php', './**/*.html', './**/*.php', './*.less', './**/*.less', './*.js', './**/*.js') " N; then
		#If user would like to specify directories
		#Setup project directories to watch
		clear
		echo "Which directory/directories are your Bootstrap files located? (Syntax INCLUDING single quotes: './*.html', './index.php', './**/*.html', './**/*.php') ";
		read BOOTSTRAP_DIR
		clear
		echo "Which directory/directories are your LESS files located? (Syntax INCLUDING single quotes: './*.less', './**/*.less')";
		read LESS_DIR
		clear
		echo "Where do you want your css file to be compiled to? (Syntax INCLUDING single quotes: './css/style.css')";
		read CSS_DIR
		clear
		echo "Which directory/directories are your JS files located? (Syntax INCLUDING single quotes: './*.js', './**/*.js')";
		read JS_DIR
	else

		BOOTSTRAP_DIR="'./*.html', './index.php', './**/*.html', './**/*.php'";
		LESS_DIR="'./*.less', './**/*.less'";
		CSS_DIR="'./css/style.css'";
		JS_DIR="'./*.js', './**/*.js'";
	fi

	clear

	echo "Making required gulp files and folders..."
	
	DIRECTORY="gulp-tasks"
	#Todo: Create gulpfile
	#Create Gulpfile.js
cat > gulpfile.js <<EOF
var html_dir = [${BOOTSTRAP_DIR}],
	less_dir = [${LESS_DIR}],
	css_dir = [${CSS_DIR}],
	js_dir = [${JS_DIR}];
/*Require All Gulp Tasks*/
var gulp = require('gulp'),
	requireDir = require('require-dir'),
	tasks = requireDir('./${DIRECTORY}');

gulp.task('default', function() {});
EOF

	if [ ! -d "$DIRECTORY" ]; then
		mkdir $DIRECTORY;
	fi
	#Create watch gulptasks
cat > ./$DIRECTORY/watch.js <<EOF
/*Project Vars*/
var paths = {
	html_dir: ['./index.html', './*.php', './**/*.html', './**/*.php'],
	less_dir: ['./*.less', './**/*.less'],
	css_dir: './css/',
	js_dir: ['./*.js', './**/*.js']
}
/*Gulp Requires*/
var gulp = require('gulp'),
	minifyCss = require('gulp-minify-css'),
	less = require('gulp-less'),
	path = require('path'),
	watch = require('gulp-watch'),
	html5Lint = require('gulp-html5-lint'),
 	jshint = require('gulp-jshint'),
 	livereload = require('gulp-livereload'),
	bootlint  = require('gulp-bootlint');

/*Watch Task*/
gulp.task('watch', function() {
	livereload.listen();

	gulp.watch(paths.less_dir).on('change', function(file) {
		return gulp.src(file.path)
		    .pipe(less({
		      paths: [ path.join(__dirname, 'less', 'includes') ]
		    }))
		    .pipe(minifyCss({keepBreaks: false}))
		    .pipe(gulp.dest(paths.css_dir))
		    .pipe(livereload());
	});

	gulp.watch(paths.html_dir).on('change', function(file) {
	    return gulp.src(file.path)
		        .pipe(bootlint({disabledIds: ['E001', 'W001', 'W002', 'W003', 'W005']}));
	});

	gulp.watch(paths.js_dir).on('change', function(file) {
	    return gulp.src(file.path)
		        .pipe(jshint());
	});
});
EOF
	echo "node_modules/" >> ".git_ignore"
	echo "...Done! Go to https://github.com/rapidwebltd to keep up to date with the latest news and updates!"
	echo "Run 'gulp watch' to start watching your files for changes and have fun!! :)"
	

else
    echo "Error: User aborted installation... Exiting..."
fi

