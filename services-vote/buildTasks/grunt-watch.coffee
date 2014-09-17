# We use ./ in watch only to prevent everything from being watched if a variable is empty...

module.exports = (grunt) ->
    grunt.config 'watch',
        buildApp:
            files: [
                './<%= config.appSrc %>/**/*'
                './<%= config.appResources %>/**/*'
                './<%= config.configDir %>/**/**/*'
                './<%= config.test %>/**/*'
                'index.coffee'
            ]
            tasks: ['rebuild']
