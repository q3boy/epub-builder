e       = require 'expect.js'
path    = require 'path'
fs      = require 'fs'
cheerio = require 'cheerio'
util    = require './util'
chapter = require '../lib/chapter'
file    = require '../lib/file'

tmpDir = __dirname + '/chaptertest'
describe 'chapter', ->
  beforeEach -> util.beforeEach tmpDir
  afterEach -> util.afterEach tmpDir

  it 'without img', (done)->
    c = chapter 'chapter title'
    c.setVolume title : 'volume title'
    c.setContent 'cont line1\r\ncont line2\r\ncont line3'
    f = file tmpDir
    c.save f, ->
      html = fs.readFileSync "#{tmpDir}/chap-1.html"
      e(html).to.match /<title>volume title - chapter title<\/title/i
      $ = cheerio.load html
      e($('h1').text()).to.be c.volume.title
      e($('h2').text()).to.be c.title
      h = ($(p).text() for p in $('p'))
      e(h).to.eql c.content
      done()

  it 'with img', (done)->
    srv = util.http ['a.jpg', 'b.jpg'], (port, close)->
      c = chapter 'chapter title', 2
      c.setVolume title : 'volume title'
      c.setContent 'cont line1\r\ncont line2\r\ncont line3'
      c.addImage "http://localhost:#{port}/a.jpg"
      c.addImage "http://localhost:#{port}/b.jpg"
      f = file tmpDir
      c.save f, ->
        html = fs.readFileSync "#{tmpDir}/chap-2.html"
        e(html).to.match /<title>volume title - chapter title<\/title/i
        $ = cheerio.load html
        e($('h1').text()).to.be c.volume.title
        e($('h2').text()).to.be c.title
        h = ($(p).text() for p in $('p'))
        e(h.slice(0, 3)).to.eql c.content
        img = ($(img).attr('src') for img in $('p > img'))
        e(img).to.eql ['img-2-1.jpg', 'img-2-2.jpg']
        close()
        done()

