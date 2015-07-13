(function() {
  var indexer, path, server;

  server = require('./server');

  indexer = require('./indexer');

  path = require('path');

  module.exports = {
    server: server,
    indexer: indexer,
    spinUp: function(jsonFolder, port) {
      var stubFolder;
      stubFolder = path.resolve(process.cwd(), jsonFolder);
      indexer.indexFolder(stubFolder);
      return server.createServer(port);
    }
  };

}).call(this);
