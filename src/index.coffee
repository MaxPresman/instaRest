server = require('./server')
indexer = require('./indexer')
path = require('path')

module.exports =
  server: server
  indexer: indexer

  spinUp: (jsonFolder, port) ->
    stubFolder = path.resolve(process.cwd(), jsonFolder)
    indexer.indexFolder(stubFolder)
    server.createServer(port)
