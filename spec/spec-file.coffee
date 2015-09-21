e = require 'expect.js'
file = require '../lib/file'
unzip = require 'unzip'
path = require 'path'
fs = require 'fs'
futil = require 'nodejs-fs-utils'

tmpDir = __dirname + '/ziptest'
describe 'file', ->
  beforeEach( ->
    try fs.mkdirSync tmpDir unless fs.existsSync tmpDir catch e
    futil.rmdirsSync tmpDir for file in fs.readdirSync tmpDir
  )
  afterEach( ->
    return unless fs.existsSync tmpDir
    futil.rmdirsSync tmpDir
  )
  it 'empty file', (done)->
    dir = "#{tmpDir}/empty"
    file(dir).save ->
      num = 0
      e(fs.readdirSync(dir).length).to.be 0
      done()
  it 'dir & text files', (done)->
    files = [
      'D aaa', 'D bbb', 'D bbb/ccc'
      'F a.txt', 'F aaa/a.txt', 'F aaa/c.txt'
      'F b.txt', 'F bbb/ccc/a.txt', 'F bbb/ccc/b.txt'
    ]
    dir = "#{tmpDir}/mixed"
    file(dir).mkdir('aaa').mkdir('bbb/ccc')
    .write('a.txt', 'a.txt').write('aaa/a.txt', 'a.txt')
    .copy("#{__dirname}/zipfiles/b.txt", 'b.txt').copy("#{__dirname}/zipfiles/c.txt", 'aaa/c.txt')
    .chdir('bbb/ccc').write('a.txt', 'a.txt').copy("#{__dirname}/zipfiles/b.txt", 'b.txt')
    .save ->
      tree = []
      futil.walkSync dir, skipErrors : true, (err, fpath, stat, next, cache)->
        tree.push "#{if stat.isFile() then 'F' else 'D'} #{path.relative dir, fpath}" if fpath isnt dir
        next()

      e(tree.sort()).to.eql files
      done()