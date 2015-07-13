(function() {
  var bunyan, logger;

  bunyan = require('bunyan');

  if (process.env.NODE_ENV === "test") {
    logger = bunyan.createLogger({
      name: require('../package.json').name,
      streams: [
        {
          path: 'test/artifacts/logs/log.txt'
        }
      ],
      level: 'info'
    });
  } else {
    logger = bunyan.createLogger({
      name: require('../package.json').name,
      streams: [
        {
          stream: process.stdout
        }
      ],
      level: 'info'
    });
  }

  module.exports = {
    getLogger: function() {
      return logger;
    },
    forComponent: function(component) {
      return logger.child({
        component: component
      });
    }
  };

}).call(this);
