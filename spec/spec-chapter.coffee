e       = require 'expect.js'
chapter = require '../lib/chapter'
file    = require '../lib/file'
path    = require 'path'
fs      = require 'fs'
util    = require './util'
cheerio = require 'cheerio'
http    = require 'http'


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

