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

gulp.task '_run_mocha_unit', ->
  gulp.src('test/unit/*', {read: false})
    .pipe(gmocha({reporter: 'spec'}))
    .once('error', (err) -> console.log(err);)

gulp.task '_coverage', ->
  gulp.src('test/unit/**/*', { read: false })
    .pipe(gblanket({instrument:['lib/'], captureFile: 'test/artifacts/coverage.html', reporter: 'html-cov'}));

gulp.task 'create_dirs', shell.task(['rm -rf test/artifacts','mkdir test/artifacts'])

gulp.task('build', ['coffeescript'])
gulp.task('test', (cb) -> runSequence('create_dirs', 'build', '_run_mocha_unit','_coverage', cb))
