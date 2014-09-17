server = require './server'
data = require './data'

# Connect to db
data.connect()

module.exports = (app) ->
    app.get '/:application/questions/:id', (request, response) ->
        clientApp = request.param 'application'
        server.getQuestionsByIds clientApp, request.param('id'), (questions) ->
            mergeResults clientApp, questions, ->
                response.send questions

    app.post '/:application/questions/:id/vote', (request, response) ->
        questionId = request.param 'id'
        clientApp = request.param 'application'
        answerId = request.body.answerId

        unless answerId
            return response.status(400).json error: 'answerId missing'

        data.saveResult
            'application': clientApp
            'questionId': questionId
            'answerId': answerId,
            (status) ->
                server.getQuestionsByIds clientApp, questionId, (questions) ->
                    mergeResults clientApp, questions, ->
                        response.send questions[0]

mergeResults = (clientApp, questions, callback) ->
    questionIds = []
    for question in questions
        questionIds.push(question.id)

    data.getResult clientApp, questionIds, (rows) ->
        for question in questions
            for answer in question.answers
                row = rows.filter (row) ->
                    answer.id is row.AnswerId
                answer.counter = if row.length then row[0].Counter else 0
        callback()