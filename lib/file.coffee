mime = require 'mimetype'
fs = require 'fs'
futil = require 'nodejs-fs-utils'
path = require 'path'

class File
  constructor : (@file) ->
    @dir = ''
    fs.mkdirSync @file unless fs.existsSync @file

  chdir : (@dir) -> @
  mkdir : (dir) ->
    dir = "#{path.join @file, @dir, dir}/"
    futil.mkdirsSync dir unless fs.existsSync dir
    @
  copy  : (from, to) ->
    fs.writeFileSync "#{path.join @file, @dir, to}", fs.readFileSync(from)
    @
  write : (file, content) ->
    fs.writeFileSync "#{path.join @file, @dir, file}", content
    @
  save : (cb)->
    cb()
    @

module.exports = (file)-> new File file
