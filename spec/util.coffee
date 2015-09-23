fs = require 'fs'
path = require 'path'
futil = require 'nodejs-fs-utils'

exports.beforeEach = (dir)->
  try fs.mkdirSync dir unless fs.existsSync dir catch e
  futil.rmdirsSync dir for file in fs.readdirSync dir
  return
exports.afterEach = (dir)->
  return unless fs.existsSync dir
  futil.rmdirsSync dir
  return
exports.walk = (dir) ->
  tree = []
  futil.walkSync dir, skipErrors : true, (err, fpath, stat, next, cache)->
    tree.push "#{if stat.isFile() then 'F' else 'D'} #{path.relative dir, fpath}" if fpath isnt dir
    next()
  tree.sort()