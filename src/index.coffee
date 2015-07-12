{mapObject} = require 'underscore'
dataStorage = require './storage'
indexer = require './indexer'
path = require 'path'

argz = process.argv.slice(2);
restify = require('restify');
stubFolder = path.resolve(process.cwd(), argz[0])

indexer.indexFolder(stubFolder)

castQuery = (queryObject) ->
  mapObject queryObject, (val, key) ->
    switch val
      when "true" then true
      when "false" then false
      else val


respond = (req, res, next) ->
  castedQueryParams = castQuery(req.query)
  dataStorage.filterBy req.params.fileName, castedQueryParams, (err, docs) ->
    res.send(docs);
    next();


server = restify.createServer();
server.use(restify.queryParser({ mapParams: false }));
server.get('/:fileName', respond);

server.on 'InternalServerError', (req, resp, route, err) ->
  console.log req
  console.log resp
  console.log err

server.listen 8080, ->
  console.log('%s listening at %s', server.name, server.url);
