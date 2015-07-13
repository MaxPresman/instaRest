(function() {
  var dataStorage, each, fs, logger, path;

  fs = require('fs');

  path = require('path');

  each = require('underscore').each;

  dataStorage = require('./storage');

  logger = require('./logger').forComponent("indexer");

  module.exports = {
    indexFolder: function(folderPath) {
      var stubFiles;
      stubFiles = fs.readdirSync(folderPath);
      logger.info("about to index folder: %s", folderPath);
      return each(stubFiles, function(stubFile) {
        var loadedFile, parsedFile, stubFilePath;
        logger.info("about to index file: %s", stubFile);
        stubFilePath = path.resolve(folderPath, stubFile);
        loadedFile = fs.readFileSync(stubFilePath, 'UTF-8');
        parsedFile = JSON.parse(loadedFile);
        dataStorage.save(stubFile, parsedFile);
        return logger.info("indexed file: %s", stubFile);
      });
    }
  };

}).call(this);
