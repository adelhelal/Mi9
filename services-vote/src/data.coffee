Q = require 'q'
mysql = require 'mysql'
env = require 'mi9-environment'

dbName = env.get 'database:name'
connection = null

module.exports.connect = () ->
    connection = mysql.createConnection
        host: env.get('database:host')
        user: env.get('database:user')
        password: env.get('database:password')
    setup()

module.exports.saveResult = (result, onSuccess) ->
    connection.query "UPDATE #{dbName}.results SET counter = counter + 1 WHERE application = ? AND questionId = ? AND answerId = ?", [result.application, result.questionId, result.answerId],
    (error, status) ->
        if error then throw new Error error
        if status.affectedRows > 0
            onSuccess if !status.message then 'Success' else status.message
        else #TODO: address concurrency issue
            connection.query "INSERT INTO #{dbName}.results SET ?", result, (error, status) ->
                if error then throw new Error error
                onSuccess if !status.message then 'Success' else status.message

module.exports.getResult = (application, questionId, onSuccess) ->
    connection.query "SELECT * FROM #{dbName}.results WHERE application = ? AND questionId IN (?)", [application, questionId],
    (error, rows, fields) ->
        if error then throw new Error error
        onSuccess rows

setup = () ->
    connection.query "CREATE TABLE IF NOT EXISTS #{dbName}.results (
     Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
     Application VARCHAR( 25 ) NOT NULL ,
     QuestionId CHAR( 36 ) NOT NULL ,
     AnswerId CHAR( 36 ) NOT NULL ,
     Counter INT NOT NULL DEFAULT 1
    ) ENGINE = MYISAM ;"

    connection.query "CREATE TABLE IF NOT EXISTS #{dbName}.audit_results (
     Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
     Application VARCHAR( 25 ) NOT NULL ,
     QuestionId CHAR( 36 ) NOT NULL ,
     AnswerId CHAR( 36 ) NOT NULL ,
     User VARCHAR( 25 ) NOT NULL
    ) ENGINE = MYISAM ;"
