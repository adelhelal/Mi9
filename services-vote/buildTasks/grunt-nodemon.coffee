fs = require 'fs'

module.exports = (grunt) ->
    grunt.config 'nodemon',
        dev:
            script: 'index.coffee'
            options:
                cwd: '<%= config.dest %>'
                callback: (nodemon) ->
                    nodemon.on 'log', (evt) ->
                        console.log evt.colour
        debug:
            script: 'index.coffee'
            options:
                cwd: '<%= config.dest %>'
                nodeArgs: ['--nodejs', '--debug']
                callback: (nodemon) ->
                    nodemon.on 'log', (evt) ->
                        console.log evt.colour
