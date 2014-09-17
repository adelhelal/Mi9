module.exports = (grunt) ->
    grunt.config 'copy',
        app:
            expand: true
            src: [
                '<%= config.appSrc %>/**'
                '<%= config.appResources %>/**'
                '<%= config.configDir %>/**'
                '<%= config.test %>/**'
                'index.coffee'
            ]
            dest: '<%= config.dest %>'
