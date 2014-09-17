Q = require 'q'
fs = require 'fs'
http = require 'http'

describe 'Ads Integration', ->

    this.timeout 30000 # Increase the mocha timeout for this spec

    context 'with dapmsn', ->

        dapUrl = 'http://ads1.msads.net/library/dapmsn.js'
        fileData = ''
        siteData = ''

        before ->

        beforeEach ->

        it 'should have both dapmsn.js and the ads1.msads.net library identical', (done) ->
            fs.readFile __dirname + '/../src/thirdParty/dap/dapmsn.js', (error, data) ->
                expect(error).to.be.null
                fileData += data.toString()
                http.get dapUrl, (response) ->
                    response.on 'data', (data) ->
                        siteData += data.toString()
                    response.on 'end', ->
                        expect(siteData).to.equal(fileData)
                        done()
                .on 'error', (error) ->
                    expect(error).to.be.null
                    done()
