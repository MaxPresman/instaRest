(function() {
  var tingo, tingoConfigurator;

  tingoConfigurator = require('tingodb')({
    memStore: true
  }).Db;

  tingo = new tingoConfigurator('', {});

  module.exports = {
    save: function(fileName, parsedJson) {
      var collection;
      collection = tingo.collection(fileName);
      return collection.insert(parsedJson);
    },
    filterBy: function(fileName, params, cb) {
      var collection;
      collection = tingo.collection(fileName);
      return collection.find(params).toArray(cb);
    }
  };

}).call(this);
