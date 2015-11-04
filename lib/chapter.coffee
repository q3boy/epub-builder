{chapter: tpl, req} = require './util'
path = require 'path'
mime = require 'mimetype'
jade = require 'jade'


class Chapter

  constructor : (@title, @num=1) ->
    @file    = "chap-#{@num}.html"
    @id      = "chap-#{@num}"
    @type    = mime.lookup @file
    @content = []
    @img     = []

  setVolume : (@volume) -> @

  setContent : (cont) ->
    @content = cont.replace(/^(\s| )+/gm, '')
    .replace(/(\s| )+$/gm, '')
    .replace(/[\r\n]+/g, '\r\n')
    .replace(/“/g, '「')
    .replace(/”/g, '」')
    .split "\r\n"
    @

  addImage : (url) ->
    @img.push img =
      url  : url
      file : "img-#{@num}-#{@img.length+1}#{path.extname url}"
      type : mime.lookup url
    @

  save : (fhandle, cb)->
    # save chap file
    html = tpl @
    fhandle.write @file, html
    return cb @ if @img.length is 0
    # save all imgs
    num = @img.length
    for {url, file} in @img
      do (url, file) =>
        req url, (data)=>
          fhandle.write file, data
          return cb(@) if 0 is --num
    @

module.exports = (title, num=1)-> new Chapter title, num
