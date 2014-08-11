gulp = require 'gulp'
plumber = require 'gulp-plumber'
jade = require 'gulp-jade'
browserify = require 'browserify'
concat = require 'gulp-concat'
mainBowerFiles = require 'main-bower-files'
source = require 'vinyl-source-stream'
sass = require 'gulp-sass'
rimraf = require 'rimraf'

gulp.task 'clean', (cb)->
  rimraf './build', cb

gulp.task 'html', ->
  gulp
    .src './source/[^_]*.jade'
    .pipe plumber()
    .pipe jade()
    .pipe gulp.dest './build/'

gulp.task 'manifest', ->
  gulp.src './source/manifest.json'
    .pipe gulp.dest './build/'

gulp.task 'js', ->
  gulp.src(mainBowerFiles(filter: /\.js$/))
    .pipe plumber()
    .pipe concat 'vendor.js'
    .pipe gulp.dest './build/js/'

  browserify
    entries: [ './source/js/main.coffee']
    extensions: ['.coffee', '.js']
  .transform 'coffeeify'
  .bundle()
  .pipe plumber()
  .pipe source 'main.js'
  .pipe gulp.dest './build/js/'

  gulp.src './source/js/background.js'
    .pipe gulp.dest './build/js/'

gulp.task 'css', ->
  gulp
    .src './source/css/**/*.{s,}css'
    .pipe plumber()
    .pipe sass()
    .pipe gulp.dest './build/css/'

gulp.task 'watch', ['build'], ->
  gulp.watch 'source/manifest.json', ['manifest']
  gulp.watch 'source/js/**/*.{js,coffee}', ['js']
  gulp.watch 'source/**/*.jade', ['html']
  gulp.watch 'source/css/**/*.{s,}css', ['css']
  gulp.watch 'bower_components/**/*.js', ['js']

gulp.task 'build', ['manifest', 'html', 'js', 'css']
gulp.task 'default', ['clean', 'build']
