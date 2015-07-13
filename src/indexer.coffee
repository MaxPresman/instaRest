fs = require 'fs';
path = require 'path'
{each} = require 'underscore'
dataStorage = require './storage'

logger = require('./logger').forComponent("indexer")

module.exports =
  indexFolder: (folderPath) ->
    stubFiles = fs.readdirSync(folderPath)

    logger.info("about to index folder: %s", folderPath)

    each stubFiles, (stubFile) ->
      logger.info("about to index file: %s", stubFile)

      stubFilePath = path.resolve(folderPath, stubFile)
      loadedFile = fs.readFileSync(stubFilePath, 'UTF-8')
      parsedFile = JSON.parse(loadedFile)

      dataStorage.save(stubFile, parsedFile)

      logger.info("indexed file: %s", stubFile)