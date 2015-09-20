archiver = require 'archiver'
mime = require 'mimetype'
fs = require 'fs'

class Zip
  constructor : (@file) ->
    @zip = archiver.create 'zip', store: true
    @zip.pipe fs.createWriteStream @file+'.epub'

  chdir : (@dir) ->
    @zip.append null, name: "#{@dir}/"
  mkdir : (dir) ->
    @zip.append null, name: "#{@dir}/#{dir}/"
    @
  copy  : (from, to) ->
    @zip.append fs.readFileSync(from), {name: "#{@dir}/#{to}", store: 0 is mime.lookup(to).indexOf 'image/'}
    @
  write : (file, content) ->
    @zip.append content, {name: "#{@dir}/#{file}", store: 0 is mime.lookup(file).indexOf 'image/'}
    @
  save : ->
    @zip.finalize()
    @

module.exports = (file)-> new Zip file
