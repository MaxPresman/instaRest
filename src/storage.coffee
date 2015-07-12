tingoConfigurator = require('tingodb')({memStore: true}).Db
tingo = new tingoConfigurator('', {});

module.exports =
  save: (fileName, parsedJson) ->
    collection = tingo.collection(fileName)
    collection.insert(parsedJson)

  filterBy: (fileName, params, cb) ->
    collection = tingo.collection(fileName)
    collection.find(params).toArray(cb)
