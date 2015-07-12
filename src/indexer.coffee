fs = require 'fs';
path = require 'path'
{each} = require 'underscore'
dataStorage = require './storage'


module.exports =
  indexFolder: (folderPath) ->
    stubFiles = fs.readdirSync(folderPath)

    each stubFiles, (stubFile) ->
      stubFilePath = path.resolve(folderPath, stubFile)
      loadedFile = fs.readFileSync(stubFilePath, 'UTF-8')
      parsedFile = JSON.parse(loadedFile)

      console.log parsedFile

      dataStorage.save(stubFile, parsedFile)