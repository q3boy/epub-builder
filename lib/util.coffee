jade    = require 'jade'
request = require 'request'
path    = require 'path'
fs      = require 'fs'


exports.req = (url, cb, retry=3, timeout=3000, pool=10) ->
  opt =
    url : url, encoding : null
    timeout: timeout, forever: true
    pool: maxSockets: pool
  # do ->
  num = retry
  rcb = (err, resp, data) ->
    if err
      num--
      if (err.code is 'ETIMEDOUT' or err.code is 'ESOCKETTIMEDOUT') and num >= 0
        console.log '!!RETRY', url
        request opt, rcb
      else
        throw err
      return
    cb data
  request opt, rcb
  return

exports.chapter  = jade.compile fs.readFileSync(path.join __dirname, '../tpl/chapter.jade'),  {filename : 'chapter.html',  pretty: true}
exports.volume   = jade.compile fs.readFileSync(path.join __dirname, '../tpl/volume.jade'),   {filename : 'volume.html',   pretty: true}
exports.book     = jade.compile fs.readFileSync(path.join __dirname, '../tpl/book.jade'),     {filename : 'book.html',     pretty: true}
exports.bookset  = jade.compile fs.readFileSync(path.join __dirname, '../tpl/bookset.jade'),  {filename : 'bookset.html',  pretty: true}
exports.toc      = jade.compile fs.readFileSync(path.join __dirname, '../tpl/toc.jade'),      {filename : 'toc.ncx',       pretty: true}
exports.metadata = jade.compile fs.readFileSync(path.join __dirname, '../tpl/metadata.jade'), {filename : 'metadata.opf',  pretty: true}

