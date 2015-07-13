restify = require('restify');
{mapObject} = require 'underscore'
dataStorage = require './storage'
logger = require('./logger').forComponent("server")

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
  logger.error(err, {req, resp, route})

module.exports =
  createServer: (port) ->
    server.listen port, ->
      logger.info({server}, "starting server");