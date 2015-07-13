bunyan = require('bunyan');

if process.env.NODE_ENV == "test"
  logger = bunyan.createLogger(
      name: require('../package.json').name
      streams: [
        {path: 'test/artifacts/logs/log.txt'}
      ]
      level: 'info'
  );
else
  logger = bunyan.createLogger(
      name: require('../package.json').name
      streams: [
        {stream: process.stdout}
      ]
      level: 'info'
  );

module.exports =
  getLogger: -> 
    logger
  forComponent: (component) -> 
    logger.child({component})