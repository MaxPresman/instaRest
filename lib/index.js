(function() {
  var argz, castQuery, dataStorage, indexer, mapObject, path, respond, restify, server, stubFolder;

  mapObject = require('underscore').mapObject;

  dataStorage = require('./storage');

  indexer = require('./indexer');

  path = require('path');

  argz = process.argv.slice(2);

  restify = require('restify');

  stubFolder = path.resolve(process.cwd(), argz[0]);

  indexer.indexFolder(stubFolder);

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
    console.log(req);
    console.log(resp);
    return console.log(err);
  });

  server.listen(8080, function() {
    return console.log('%s listening at %s', server.name, server.url);
  });

}).call(this);
