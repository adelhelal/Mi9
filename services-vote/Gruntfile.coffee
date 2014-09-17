fs = require 'fs'
path = require 'path'
matchdep = require 'matchdep'

module.exports = (grunt) ->
    matchdep.filterDev('grunt-*').forEach(grunt.loadNpmTasks)

    grunt.initConfig
        pkg: require './package.json'
        config:
            appSrc: 'src'
            appResources: 'resources'
            configDir: 'config'
            test: 'debug'
            dest: 'build'

    for file in fs.readdirSync './buildTasks'
        if path.extname(file) == '.js' or path.extname(file) == '.coffee'
            require("./buildTasks/#{file}")(grunt)

