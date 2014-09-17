module.exports = (grunt) ->
    grunt.registerTask 'prebuild', ['clean', 'copy']
    grunt.registerTask 'rebuild', ['copy']
    grunt.registerTask 'default', ['prebuild', 'concurrent:dev']
