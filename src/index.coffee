fs = require 'fs';
path = require 'path'
{each, mapObject} = require 'underscore'
tingoConfigurator = require('tingodb')({memStore: true}).Db
argz = process.argv.slice(2);
restify = require('restify');


tingo = new tingoConfigurator('/Users/mpresman/Desktop/OSS_control/instaAPI', {});

stubFolder = path.resolve(process.cwd(), argz[0])
stubFiles = fs.readdirSync(stubFolder)

each stubFiles, (stubFile) ->
  stubFilePath = path.resolve(stubFolder, stubFile)
  loadedFile = fs.readFileSync(stubFilePath, 'UTF-8')

  ## create a collection for this file
  collection = tingo.collection(stubFile)

  parsedFile = JSON.parse(loadedFile)

  collection.insert(parsedFile)

castQuery = (queryObject) ->
  mapObject queryObject, (val, key) ->
    switch val
      when "true" then true
      when "false" then false
      else val


respond = (req, res, next) ->
  collection = tingo.collection(req.params.fileName)

  castedQueryParams = castQuery(req.query)

  collection.find(castedQueryParams).toArray (err, docs) ->
    res.send(docs);
    next();


server = restify.createServer();
server.use(restify.queryParser({ mapParams: false }));
server.get('/:fileName', respond);

server.listen 8080, ->
  console.log('%s listening at %s', server.name, server.url);
