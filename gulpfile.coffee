gulp = require('gulp')
coffee = require('gulp-coffee')
watch = require('gulp-watch')
gutil = require('gulp-util')
gmocha = require('gulp-mocha')
gblanket = require('gulp-blanket-mocha')
shell = require('gulp-shell')
runSequence = require('run-sequence')

gulp.task 'coffeescript', ->

  gulp.src('src/**/*.coffee')
    .pipe(coffee({bare: false}).on('error', gutil.log))
    .pipe(gulp.dest('./lib/'))

gulp.task 'watch', ->
  gulp.watch('src/**', ['build']);

gulp.task '_run_mocha', ->
  gulp.src('test/**/*_test.coffee', {read: false})
    .pipe(gmocha({reporter: 'spec'}))
    .once('error', (err) -> console.log(err);)

gulp.task 'set-test-env', ->
  return process.env.NODE_ENV = 'test'

gulp.task 'set-dev-env', ->
  return process.env.NODE_ENV = 'development'

gulp.task 'start-dev-server', ->
  instaRest = require './lib/index'
  instaRest.spinUp("test/stubs",8080)

gulp.task '_coverage', ->
  gulp.src('test/**/*_test.coffee', { read: false })
    .pipe(gblanket({instrument:['lib/'], captureFile: 'test/artifacts/coverage.html', reporter: 'html-cov'}));

gulp.task 'create_dirs', shell.task(['rm -rf test/artifacts','mkdir test/artifacts', 'mkdir test/artifacts/logs'])

gulp.task('build', ['coffeescript'])
gulp.task('develop', (cb) -> runSequence('set-dev-env','create_dirs', 'build', 'start-dev-server', cb))
gulp.task('test', (cb) -> runSequence('set-test-env','create_dirs', 'build', '_run_mocha','_coverage', cb))
