gulp = require('gulp')
coffee = require('gulp-coffee')
watch = require('gulp-watch')
gutil = require('gulp-util')
gmocha = require('gulp-mocha')

gulp.task 'coffeescript', ->

  gulp.src('src/**/*.coffee')
    .pipe(coffee({bare: false}).on('error', gutil.log))
    .pipe(gulp.dest('./lib/'))

gulp.task 'watch', ->
  gulp.watch('src/**', ['build']);

gulp.task 'run_mocha_unit', ->
  gulp.src('test/unit/**/*', {read: false}).pipe(gmocha({reporter: 'spec'}));

gulp.task('build', ['coffeescript'])
gulp.task('test', ['build', 'run_mocha_unit'])
