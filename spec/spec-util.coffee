e       = require 'expect.js'
{http}  = require './util'
{req}   = require '../lib/util'

describe 'util', ->
  describe 'req', ->
    close = url = add = srv = null
    before (done)->
      srv = http (port, cl, ad)->
        close = cl
        add = ad
        url = "http://localhost:#{port}/"
        done()
    after (done)->
      close done
    body = 'hello world'
    tm = ->
    xit 'without retry', (done)->
      add body
      req url, (err, data)->
        e(err).to.be null
        e(data.toString()).to.be body
        done()
    it 'with 2 retries', (done)->
      add [tm, tm, body]
      req url, (err, data, retry)->
        e(err).to.be null
        e(retry).to.be 2
        e(data.toString()).to.be body
        done()
      , timeout : 50
    it 'retry out of times', (done)->
      add [tm, tm, tm, body]
      req url, (err, data, retry)->
        e(err.code).to.be 'ETIMEDOUT'
        e(retry).to.be 3
        e(data).to.be null
        done()
      , timeout : 50, retry:2