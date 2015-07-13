(function() {
  var castQuery, dataStorage, logger, mapObject, respond, restify, server;

  restify = require('restify');

  mapObject = require('underscore').mapObject;

  dataStorage = require('./storage');

  logger = require('./logger').forComponent("server");

  castQuery = function(queryObject) {
    return mapObject(queryObject, function(val, key) {
      switch (val) {
        case "true":
          return true;
        case "false":
          return false;
        default:
          return val;
      }
    });
  };

  respond = function(req, res, next) {
    var castedQueryParams;
    castedQueryParams = castQuery(req.query);
    return dataStorage.filterBy(req.params.fileName, castedQueryParams, function(err, docs) {
      res.send(docs);
      return next();
    });
  };

  server = restify.createServer();

  server.use(restify.queryParser({
    mapParams: false
  }));

  server.get('/:fileName', respond);

  server.on('InternalServerError', function(req, resp, route, err) {
    return logger.error(err, {
      req: req,
      resp: resp,
      route: route
    });
  });

  module.exports = {
    createServer: function(port) {
      return server.listen(port, function() {
        return logger.info({
          server: server
        }, "starting server");
      });
    }
  };

}).call(this);
