e = require 'expect.js'
zip = require '../lib/zip'
unzip = require 'unzip'
fs = require 'fs'

tmpDir = __dirname + '/ziptest'
describe 'zip', ->
  beforeEach( ->
    try fs.mkdirSync tmpDir unless fs.existsSync tmpDir catch e
    fs.unlinkSync "#{tmpDir}/#{file}" for file in fs.readdirSync tmpDir
  )
  afterEach( ->
    return unless fs.existsSync tmpDir
    fs.unlinkSync "#{tmpDir}/#{file}" for file in fs.readdirSync tmpDir
    fs.rmdirSync tmpDir
  )
  it 'empty file', (done)->
    zip("#{tmpDir}/empty").save ->
      num = 0
      fs.createReadStream(tmpDir+'/empty.epub')
      .pipe unzip.Parse()
      .on 'entry', (entry) ->
        num++
      .on 'close', ->
        e(num).to.be 0
        done()
  it 'dir & text files', (done)->
    files = [
      'D aaa/', 'D bbb/ccc/'
      'F a.txt', 'F aaa/a.txt', 'F aaa/c.txt'
      'F b.txt', 'F bbb/ccc/a.txt', 'F bbb/ccc/b.txt'
    ]
    zip("#{tmpDir}/mixed").mkdir('aaa').mkdir('bbb/ccc')
    .write('a.txt', 'a.txt').write('aaa/a.txt', 'a.txt')
    .copy("#{__dirname}/zipfiles/b.txt", 'b.txt').copy("#{__dirname}/zipfiles/c.txt", 'aaa/c.txt')
    .chdir('bbb/ccc').write('a.txt', 'a.txt').copy("#{__dirname}/zipfiles/b.txt", 'b.txt')
    .save ->
      tree = []
      fs.createReadStream(tmpDir+'/mixed.epub')
      .pipe unzip.Parse()
      .on 'entry', (entry) ->
        name = "#{entry.type.substr 0, 1} #{entry.path}"
        tree.push name if 0 > tree.indexOf name
        entry.autodrain()
      .on 'close', ->
        e(tree.sort()).to.eql files
        done()