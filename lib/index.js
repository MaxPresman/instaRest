(function() {
  var argz, castQuery, each, fs, mapObject, path, ref, respond, restify, server, stubFiles, stubFolder, tingo, tingoConfigurator;

  fs = require('fs');

  path = require('path');

  ref = require('underscore'), each = ref.each, mapObject = ref.mapObject;

  tingoConfigurator = require('tingodb')({
    memStore: true
  }).Db;

  argz = process.argv.slice(2);

  restify = require('restify');

  tingo = new tingoConfigurator('/Users/mpresman/Desktop/OSS_control/instaAPI', {});

  stubFolder = path.resolve(process.cwd(), argz[0]);

  stubFiles = fs.readdirSync(stubFolder);

  each(stubFiles, function(stubFile) {
    var collection, loadedFile, parsedFile, stubFilePath;
    stubFilePath = path.resolve(stubFolder, stubFile);
    loadedFile = fs.readFileSync(stubFilePath, 'UTF-8');
    collection = tingo.collection(stubFile);
    parsedFile = JSON.parse(loadedFile);
    return collection.insert(parsedFile);
  });

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
    var castedQueryParams, collection;
    collection = tingo.collection(req.params.fileName);
    castedQueryParams = castQuery(req.query);
    return collection.find(castedQueryParams).toArray(function(err, docs) {
      res.send(docs);
      return next();
    });
  };

  server = restify.createServer();

  server.use(restify.queryParser({
    mapParams: false
  }));

  server.get('/:fileName', respond);

  server.listen(8080, function() {
    return console.log('%s listening at %s', server.name, server.url);
  });

}).call(this);
