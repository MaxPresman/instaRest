assert = require 'assert'
indexer = require '../../lib/indexer'
fs = require 'fs'
path = require 'path'
sinon = require 'sinon'
dataStorage = require '../../lib/storage'
stubbedDataStorage = null


describe "JSON --> database indexer", ->
  describe "#indexFolder", ->

    beforeEach ->
      sinon.stub(fs, "readdirSync", -> ["a.json", "b.json", "c.json"] )
      sinon.stub(fs, "readFileSync", (stubFilePath) ->
        baseFileName = path.basename(stubFilePath)
        JSON.stringify({"cool": baseFileName})) 
      stubbedDataStorage = sinon.stub(dataStorage, "save")

    afterEach ->
      fs.readdirSync.restore()
      fs.readFileSync.restore()
      stubbedDataStorage.restore()


    it "should call storage three times for each json file", ->
      indexer.indexFolder("dummyFolder")
      assert.equal stubbedDataStorage.callCount, 3
      
    it "should contain the files / parsed json as args", ->
      indexer.indexFolder("dummyFolder")
      assert.deepEqual stubbedDataStorage.args, [
        ["a.json",{"cool":"a.json"}],
        ["b.json",{"cool":"b.json"}],
        ["c.json",{"cool":"c.json"}]
      ]