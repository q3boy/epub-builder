archiver = require 'archiver'
mime = require 'mimetype'
fs = require 'fs'
path = require 'path'

class Zip
  constructor : (@file) ->
    @dir = ''
    @zip = archiver.create 'zip', store: true
    @stream = fs.createWriteStream @file+'.epub'
    @zip.pipe @stream

  chdir : (@dir) ->
    @zip.append null, name: "#{path.normalize @dir}/"
    @
  mkdir : (dir) ->
    @zip.append null, name: "#{path.join @dir, dir}/"
    @
  copy  : (from, to) ->
    @write to, fs.readFileSync from

  write : (file, content) ->
    @zip.append content,
      name: path.join @dir, file
      store: 0 is mime.lookup(file).indexOf 'image/'
    @
  save : (cb)->
    @stream.on 'close', cb

    @zip.finalize()
    @

module.exports = (file)-> new Zip file
module.exports.Zip = Zip