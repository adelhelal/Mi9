module.exports = (grunt) ->
    grunt.config 'concurrent',
        dev:
            tasks: ['nodemon:dev', 'watch']
            options: 
                logConcurrentOutput: true

        debug:
            tasks: ['nodemon:debug', 'watch']
            options: 
                logConcurrentOutput: true
