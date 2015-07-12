(function() {
  var dataStorage, each, fs, path;

  fs = require('fs');

  path = require('path');

  each = require('underscore').each;

  dataStorage = require('./storage');

  module.exports = {
    indexFolder: function(folderPath) {
      var stubFiles;
      stubFiles = fs.readdirSync(folderPath);
      return each(stubFiles, function(stubFile) {
        var loadedFile, parsedFile, stubFilePath;
        stubFilePath = path.resolve(folderPath, stubFile);
        loadedFile = fs.readFileSync(stubFilePath, 'UTF-8');
        parsedFile = JSON.parse(loadedFile);
        console.log(parsedFile);
        return dataStorage.save(stubFile, parsedFile);
      });
    }
  };

}).call(this);
