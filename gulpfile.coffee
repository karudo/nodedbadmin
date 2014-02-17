gulp = require 'gulp'
coffee = require 'gulp-coffee'
browserify = require 'gulp-browserify'

gulp.task 'scripts', ->
  gulp.src('client/app/**/*.coffee')
  .pipe(coffee())
  .pipe(browserify())
  .pipe(gulp.dest('aaa.js'))