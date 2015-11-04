jade    = require 'jade'
request = require 'request'
http    = require 'http'
path    = require 'path'
url     = require 'url'
fs      = require 'fs'

exports.req = (url, cb, options={}) ->
  retry = options.retry or 3
  timeout = options.timeout or 3000
  pool = options.pool or 8

  opt =
    url : url, encoding : null
    timeout: timeout, forever: true
    pool : maxSockets: pool
  num = retry
  rcb = (err, resp, data) ->
    if err
      num--
      return request opt, rcb if (err.code is 'ETIMEDOUT' or err.code is 'ESOCKETTIMEDOUT') and num >= 0
      return cb err, null, retry - num
    cb null, data, retry - num
  request opt, rcb
  return

tpl = [
  ['chapter', 'html'], ['volume', 'html'], ['book', 'html'],
  ['bookset', 'html'], ['toc', 'ncx'], ['metadata', 'opf']
]
for [name, ext] in tpl
  exports[name] =  jade.compile(
    fs.readFileSync(path.join __dirname, '../tpl/', name+'.jade')
    fileanme: "#{name}.#{ext}", pretty: true
  )