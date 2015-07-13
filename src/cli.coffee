path = require('path')
program = require('commander')
instaRest = require('./index')

program
  .version(require('../package.json').version)
  .option('-p, --port <n>', 'Port to run the server on', parseInt, 8080)
  .option('-d, --directory <directory>', 'where to find json files', '.')
  .parse(process.argv);

instaRest.spinUp(program.directory, program.port)