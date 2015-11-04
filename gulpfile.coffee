gulp   = require 'gulp'
mocha  = require 'gulp-mocha'
util   = require 'gulp-util'
istan  = require 'gulp-coffee-istanbul'
seq    = require 'gulp-sequence'
noti   = require 'mocha-notifier-reporter'
futil  = require 'nodejs-fs-utils'
fs     = require 'fs'
deps   = require './deps'



spec = ['spec/**/spec-*.coffee']
cs   = ['lib/**/*.coffee']
js   = ["lib/**/*.js"]
clean = ['coverage']

wfiles = js.concat(cs).concat(spec)
watch = -> gulp.watch wfiles, (evt)->
  if evt.type is 'changed'
    deps ['./lib', './spec'], spec, ->
      gulp.src @find(evt.path), read: false
      .pipe mocha reporter: noti.decorate 'tap'
    return
  gulp.src spec, read: false
  .pipe mocha reporter: noti.decorate 'tap'

# gulp.task 'jscpd',  ->
#   gulp.src js.concat cs
#   .pipe jscpd
#     'min-lines' : 5
#     'min-tokens' : 50
#     verbose    : false

gulp.task 'mocha', (done)->
  task = gulp.src spec, read: false
  .pipe mocha reporter: noti.decorate 'tap'

gulp.task 'istanbul', (done)->
  gulp.src js.concat cs
  .pipe istan includeUntested: true
  .pipe istan.hookRequire()
  .on 'finish', ->
    gulp.src spec
    .pipe mocha reporter: noti.decorate 'tap'
    .pipe istan.writeReports()
#    .on 'finish', ->
#      setTimeout process.exit, 100
#
gulp.task 'clean',  -> futil.rmdirsSync dir for dir in clean when fs.existsSync dir
gulp.task 'default', seq('clean', 'mocha')
gulp.task 'cover',   seq('clean', 'istanbul')
# gulp.task 'watch', -> gulp.watch wfiles, ['mocha']
gulp.task 'watch', watch
gulp.task 'dev', seq('default', 'watch')
