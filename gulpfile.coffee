gulp = require('gulp')
coffee = require('gulp-coffee')
watch = require('gulp-watch')
gutil = require('gulp-util')

gulp.task 'coffeescript', ->

  gulp.src('src/**/*.coffee')
    .pipe(coffee({bare: false}).on('error', gutil.log))
    .pipe(gulp.dest('./lib/'))

gulp.task 'watch', ->
  gulp.watch('frontend/**', ['build']);

gulp.task('build', ['coffeescript'])
