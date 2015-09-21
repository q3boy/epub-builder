gulp  = require 'gulp'
mocha = require 'gulp-mocha'
util  = require 'gulp-util'
# notify  = require 'node-notify'
noti  = require 'mocha-notifier-reporter'
istan = require 'gulp-coffee-istanbul'

# spec = ['spec/**/spec-*.coffee']
spec = ['spec/**/spec-*.coffee']
cs = ['lib/**/*.coffee']
js = ["lib/**/*.js", 'index.js']

wfiles = js.concat(cs).concat(spec)


gulp.task 'test', (cb)->
  gulp.src(spec, read: false)
  .pipe(mocha reporter: noti.decorate 'list')
  # .on('error', util.log)

gulp.task 'test-cov', (cb)->
  gulp.src(js.concat cs)
  .pipe istan includeUntested: true
  .pipe istan.hookRequire()
  .on 'finish', ->
    gulp.src spec
      .pipe mocha reporter: noti.decorate 'list'
      .pipe istan.writeReports()



gulp.task 'dev', ['watch', 'test'], ->

gulp.task 'default', ['dev'], ->

gulp.task 'watch', ->
  gulp.watch wfiles, ['test']
