http  = require 'http'
fs    = require 'fs'
path  = require 'path'
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

exports.http = (resps=[], cb) ->
  if arguments.length is 1
    cb = resps
    resps = []
  else
    resps = [resps] unless Array.isArray resps
  srv = http.createServer (req, resp)->

    r = resps.shift()
    if typeof r is 'function'
      r resp
    else
      resp.end r
  .on 'listening', ->
    cb srv.address().port, ((cb1) ->srv.close(cb1)), (body)->
      body = [body] unless Array.isArray body
      for b in body
        resps.push b
  .listen()
  .setTimeout 500



  # setTimeout (->
  #   srv.close()
  # ), 1000


